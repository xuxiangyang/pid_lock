require "pid_lock/version"
require 'fileutils'

module PidLock
  class << self
    attr_writer :pid_path
    def pid_path
      @pid_path || "tmp/pid_locks"
    end

    def ensure_single_running(pid_name)
      return if locked?(pid_name)
      PidLock.lock(pid_name)
      begin
        yield
      ensure
        PidLock.unlock(pid_name)
      end
    end

    def lock(pid_name)
      Dir.exist?(pid_path) || FileUtils.mkdir_p(pid_path)
      File.write(File.join(pid_path, "#{pid_name}.pid"), $PID)
    end

    def locked?(pid_name)
      return false unless File.exist?(File.join(pid_path, "#{pid_name}.pid"))
      begin
        Process.kill(0, pid(pid_name))
        return true
      rescue StandardError
        self.unlock(pid_name)
        return false
      end
    end

    def stop(pid_name)
      return unless File.exist?(File.join(pid_path, "#{pid_name}.pid"))
      pid = File.read(File.join(pid_path, "#{pid_name}.pid"))
      return if pid.to_s.empty?
      begin
        Process.kill("TERM", pid.to_i)
      rescue StandardError
      end
      unlock(pid_name)
    end

    def pid(pid_name)
      File.read(File.join(pid_path, "#{pid_name}.pid")).to_i
    end

    def unlock(pid_name)
      if File.exist?(File.join(pid_path, "#{pid_name}.pid"))
        File.delete(File.join(pid_path, "#{pid_name}.pid"))
      end
    end
  end
end
