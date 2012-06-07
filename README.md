## secured_fileutils.rb

Ruby標準のFileUtilsの代用品です。あらかじめ操作対象のパスを指定しておくことで、誤って親階層のディレクトやファイルが操作されてしまうことを防ぎます。

次のように操作対象のパス名を指定してnewします。

	fileutil = SecuredFileUtils.new(dir1, dir2, …)

あとはmkdir、cp、rm、rmdirが使用できます。

## sync_dir.rb

2つのディレクトリを比較して差分で同期します。

	SyncDir(src_dir, dst_dir).new.sync
