require "logger"
require "dirdiff"
require "secured_fileutils"

class SyncDir

  def initialize(src_path, dst_path, logger=Logger.new(STDOUT))
    @src_path = src_path
    @dst_path = dst_path
    @log = logger
    @diff = DirDiff.new(dst_path, src_path)
    @util = SecuredFileUtils.new(src_path, dst_path)
  end

  def sync
    @diff.each do |fname, type, operation|
      #@log.info(sprintf("%-16s %-10s %s\n", fname.inspect, type.inspect, operation.inspect))
      src = File.expand_path(@src_path + "/" + fname)
      dst = File.expand_path(@dst_path + "/" + fname)
      if operation == :modified
        @log.info("cp #{src} #{dst}")
        @util.cp(src, dst)
      elsif operation == :added
        if type == :directory
          @log.info("mkdir #{dst}")
          @util.mkdir(dst)
        else
          @log.info("cp #{src} #{dst}")
          @util.cp(src, dst)
        end
      elsif operation == :deleted
        if type == :directory
          @log.info("rmdir #{dst}")
          @util.rmdir(dst)
        else
          @log.info("rm #{dst}")
          @util.rm(dst)
       end
      end
    end
  end

end
