# Simple BDD API for testing asynchronous Ruby/EventMachine code

`em-spec` can be used with either bacon, test unit or rspec.

## Rspec
There are two ways to use with the Rspec gem.

To use it as a helper, include `EM::SpecHelper` in your describe block.
You then use the `em` method to wrap your evented test code.

Inside the `em` block, you must call `done` after your expectations.
Everything works normally otherwise.

```ruby
  require "em-spec/rspec"
  describe EventMachine do
    include EM::SpecHelper
  
    it "works normally when not using #em" do
      1.should == 1
    end
  
    it "makes testing evented code easy with #em" do
      em do
        start = Time.now

        EM.add_timer(0.5){
          (Time.now-start).should be_close( 0.5, 0.1 )
          done
        }
      end
    end
  end
```

The other option is to include `EM::Spec` in your describe block.

This will patch Rspec so that all of your examples run inside an `em` block automatically:

```ruby
  require "em-spec/rspec"
  describe EventMachine do
    include EM::Spec
    
    it "requires a call to #done every time" do
      1.should == 1
      done
    end
    
    it "runs test code in an em block automatically" do
      start = Time.now

      EM.add_timer(0.5){
        (Time.now-start).should be_close( 0.5, 0.1 )
        done
      }
    end
  end
```

## Bacon

The API is identical to Bacon, except that you must explicitly call `done`
after all the current behavior's assertions have been made:

```ruby
  require 'em-spec/bacon'

  EM.describe EventMachine do

    should 'have timers' do
      start = Time.now

      EM.add_timer(0.5){
        (Time.now-start).should.be.close 0.5, 0.1
        done
      }
    end

    should 'have periodic timers' do
      num = 0
      start = Time.now

      timer = EM.add_periodic_timer(0.5){
        if (num += 1) == 2
          (Time.now-start).should.be.close 1.0, 0.1
          EM.__send__ :cancel_timer, timer
          done
        end
      }
    end

  end
```

## `Test::Unit`

There are two ways to use the `Test::Unit` extension.

To use it as a helper, include `EM::TestHelper` in your test unit class.

You then use the em method to wrap your evented test code.

Inside the em block, you must call `done` after your expectations.
Everything works normally otherwise.

```ruby
  require 'em-spec/test'

  class EmSpecHelperTest < Test::Unit::TestCase
    include EventMachine::TestHelper
  
    def test_trivial
      em do
        assert_equal 1, 1
        done
      end
    end
  end
```

The other option is to include `EM::Test` in your test class.

This will patch `Test::Unit` so that all of your examples run inside an
`em` block automatically:

```ruby
  require 'em-spec/test'

  class EmSpecTest < Test::Unit::TestCase
  
    include EventMachine::Test

    def test_timer
      start = Time.now

      EM.add_timer(0.5){
        assert_in_delta 0.5, Time.now-start, 0.1
        done
      }
    end
  end
```

## Resources

* [Bacon](http://groups.google.com/group/comp.lang.ruby/browse_thread/thread/30b07b651b0662fd)
