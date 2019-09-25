require 'eventmachine'
require File.dirname(__FILE__) + '/../ext/fiber18'

module EventMachine
  module SpecHelper
    
    SpecTimeoutExceededError = Class.new(RuntimeError)
    
    def self.included(cls)
      ::RSpec::Core::ExampleGroup.instance_eval "
      @@_em_default_time_to_finish = nil
      def self.default_timeout(timeout)
        @@_em_default_time_to_finish = timeout
      end
      "
    end
    
    def timeout(time_to_run)
      EM.cancel_timer(@_em_timer) if @_em_timer
      @_em_timer = EM.add_timer(time_to_run) { done; raise SpecTimeoutExceededError.new }
    end
    
    def em(time_to_run = @@_em_default_time_to_finish, &block)
      em_spec_exception = nil

      EM.run do
        timeout(time_to_run) if time_to_run
        @_em_spec_fiber = Fiber.new do
          begin
            block.call
          rescue Exception => em_spec_exception
            done
          end
          Fiber.yield
        end  

        @_em_spec_fiber.resume
      end

      raise em_spec_exception if em_spec_exception
    end

    def done
      EM.next_tick{
        finish_em_spec_fiber
      }
    end

    private

    def finish_em_spec_fiber
      EM.stop_event_loop if EM.reactor_running?
      @_em_spec_fiber.resume if @_em_spec_fiber.alive?
    end
    
  end

  module Spec
    
    include SpecHelper

    def self.append_features(mod)
      mod.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        around(:all) do |example|
          em do
            example.run
          end
        end
      RUBY
    end

  end


end


