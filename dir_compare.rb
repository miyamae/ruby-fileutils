require "fileutils"

class DirCompare

  def self.file_compare(src, dst)
    if ! FileTest.exist?(dst)
      op = :added
    elsif ! FileTest.exist?(src)
      op = :deleted
    elsif (!FileUtils.cmp(src, dst) rescue false)
      op = :modified
    else
      op = false
    end
    {
      :name => File.basename(src),
      :operation => op,
      :directory => FileTest.directory?(src),
      :mtime => op != :deleted ? File.mtime(src) : nil,
      :ctime => op != :deleted ? File.ctime(src) : nil,
    }
  end

  def self.diff_shallow(src_path, dst_path)
    result = []
    Dir.glob("#{src_path}/.*\0#{src_path}/*") do |src|
      name = File.basename(src)
      unless name =~ /^\.+$/
        spath = src.gsub(/^#{Regexp.escape(src_path)}\/+/, "/")
        dst = dst_path + spath
        result << file_compare(src, dst)
      end
    end
    Dir.glob("#{dst_path}/.*\0#{dst_path}/*") do |dst|
        spath = dst.gsub(/^#{Regexp.escape(dst_path)}\/+/, "/")
        src = src_path + spath
        if ! FileTest.exist?(src)
          result << file_compare(src, dst)
        end
    end
    result
  end

end
