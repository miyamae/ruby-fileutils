require "fileutils"

class SecuredFileUtils

  def initialize(*dirs)
    @dirs = dirs
  end

  def protect_path(dir)
    full_path = File.expand_path(dir)
    @dirs.each do |d|
      if full_path =~ /^#{Regexp.escape(File.expand_path(d))}/
        return true
      end
    end
    raise "SecuredFileUtils proteted: " + full_path
  end

  def mkdir(path)
    protect_path path
    FileUtils.mkdir(path)
  end

  def cp(src, dst)
    protect_path src
    protect_path dst
    FileUtils.cp(src, dst)
  end

  def rm(path)
    protect_path path
    if FileTest.directory?(path)
      FileUtils.rmdir(path)
    else
      FileUtils.rm(path)
    end
  end

  def rmdir(path)
    protect_path path
    FileUtils.rmdir(path)
  end

end
