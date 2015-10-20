require 'test/unit'
require "pry"
require "pid_lock"

class TestPidLock < Test::Unit::TestCase
  def test_lock
    PidLock.lock('test')
    assert_equal true, PidLock.locked?('test')
    assert_equal true, File.exist?(File.join(PidLock.pid_path, "test.pid"))
  end

  def test_unlock
    PidLock.lock('test')
    assert_equal true, PidLock.locked?('test')
    assert_equal true, File.exist?(File.join(PidLock.pid_path, "test.pid"))
    PidLock.unlock('test')
    assert_equal false, PidLock.locked?('test')
    assert_equal false, File.exist?(File.join(PidLock.pid_path, "test.pid"))
  end

  def test_stop
    PidLock.lock('test')
    PidLock.stop("test")
    assert_equal false, PidLock.locked?('test')
  end
end
