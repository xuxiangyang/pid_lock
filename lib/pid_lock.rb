require "pid_lock/version"
require 'fileutils'

module PidLock
  class << self
    @@pid_path = nil

    def pid_path=(path)
      @@pid_path = path
    end

    def pid_path
      @@pid_path || "tmp/pid_locks"
    end

    def lock(pid_name)
      Dir.exists?(pid_path) or FileUtils.mkdir_p(pid_path)
      File.write(File.join(pid_path, "#{pid_name}.pid"), $$)
    end

    def locked?(pid_name)
      return false unless File.exists?(File.join(pid_path, "#{pid_name}.pid"))
      begin
        Process.kill(0, pid(pid_name))
        return true
      rescue
        self.unlock(pid_name)
        return false
      end
    end

    def stop(pid_name)
      return unless File.exists?(File.join(pid_path, "#{pid_name}.pid"))
      pid = File.read(File.join(pid_path, "#{pid_name}.pid"))
      unless pid.to_s.empty?
        Process.kill("TERM", pid.to_i) rescue nil
      end
      unlock(pid_name)
    end

    def pid(pid_name)
      File.read(File.join(pid_path, "#{pid_name}.pid")).to_i
    end

    def unlock(pid_name)
      if File.exists?(File.join(pid_path, "#{pid_name}.pid"))
        File.delete(File.join(pid_path, "#{pid_name}.pid"))
      end
    end
  end
end
