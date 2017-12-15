Util Scripts for Mounting Object Storage (S3)
===================

These util scripts are used for conveniently mounting object storage with s3 interfaces on Ubuntu.

* install_s3cmd.sh 		-	Install [s3cmd](https://github.com/s3tools/s3cmd) from deb repository sources.
* install_s3fs.sh 		- 	Install [s3fs](https://github.com/s3fs-fuse/s3fs-fuse) from github.
* config_s3cmd.sh 		-	Generate s3cmd configuration file.
* mount_s3fs.sh 		-	Mount S3 Storage Bucket


# Usage:


[s3cmd](https://github.com/s3tools/s3cmd) 可用来管理S3 Storage，./install_s3cmd.sh 进行安装，之后可以直接输入s3cmd查看用法。

正式使用前还需要配置连接参数，可以使用./config_s3cmd.sh 方便的生成配置文件，根据提示输入参数即可。

s3cmd基本用法有：
	
*	s3cmd ls 						-	列举全部bucket

*	s3cmd ls s3://[Bucket]/[Prefix]	-	列举指定bucket下指定前缀的Object

*	s3cmd mb s3://[Bucket]			-	创建bucket

*	s3cmd rb s3://[Bucket]			-	删除bucket


--------------------------------------------------------------------------------------------------------------

挂载Bucket到本地目录：

	./mount_s3fs.sh Bucket MountPoint [s3fs_option1] [s3fs_option2] ...]

使用s3fs进行挂载，默认指定了allow_other, use_path_request_style和sigv2三个参数，其他s3fs的参数，可以在脚本第三个以后的参数指定。

如果s3fs未安装，会提醒是否自动安装，y/n选择。

如果MountPoint不存在，会提醒是否新建本地目录，y/n选择。

如果MountPoint非空，会提醒是否继续挂载，y/n选择。

如果未指定s3fs的url参数，会提示输入服务器地址，如果是https协议连接，输入https://[ServerUrl]
，否则默认http协议连接。

如果未指定passwd_file参数，会提示输入Access Key和Key Secret，自动生成passwd_file。

挂载成功后可以选择将挂载信息写入/etc/fstab，以后启动会自动挂载

--------------------------------------------------------------------------------------------------------------


## References

* [http://s3tools.org/s3cmd](http://s3tools.org/s3cmd)

* [https://github.com/s3tools/s3cmd](https://github.com/s3tools/s3cmd)

* [https://github.com/s3fs-fuse/s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse)

* [https://en.wikipedia.org/wiki/Filesystem_in_Userspace](https://en.wikipedia.org/wiki/Filesystem_in_Userspace)


--------------------------------------------------------------------------------------------------------------------------------------