Utils Scripts for Mounting Object Storage
===================

* install_s3cmd.sh 		-	Install [https://github.com/s3tools/s3cmd](s3cmd) from deb repository sources.
* install_s3fs.sh 		- 	Install [https://github.com/s3fs-fuse/s3fs-fuse](s3fs) from github.
* mount_s3fs.sh 		-	Mount S3 Storage Bucket


# Usage:


[https://github.com/s3tools/s3cmd](s3cmd) 可用来管理S3 Storage，./install_s3cmd.sh 进行安装，之后可以直接输入s3cmd查看用法。
基本用法有：
	s3cmd ls 						-	列举全部bucket
	s3cmd ls s3://[Bucket]/[Prefix]	-	列举指定bucket下指定前缀的Object
	s3cmd mb s3://[Bucket]			-	创建bucket
	s3cmd rb s3://[Bucket]			-	删除bucket

--------------------------------------------------------------------------------------------------------------

挂载Bucket到本地目录：

	./mount_s3fs.sh [Bucket] [MountPoint]	

如果MountPoint不存在，会提醒是否新建本地目录，y/n选择。

如果MountPoint非空，会提醒是否继续挂载，y/n选择。

之后要输入服务器地址，如果是https协议连接，输入https://[ServerUrl]，否则默认http协议连接。

然后输入Access Key和Key Secret

挂载成功后可以选择将挂载信息写入/etc/fstab，以后启动会自动挂载

--------------------------------------------------------------------------------------------------------------


## References

* [http://s3tools.org/s3cmd](http://s3tools.org/s3cmd)

* [https://github.com/s3tools/s3cmd](https://github.com/s3tools/s3cmd)

* [https://github.com/s3fs-fuse/s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse)

* [https://en.wikipedia.org/wiki/Filesystem_in_Userspace](https://en.wikipedia.org/wiki/Filesystem_in_Userspace)


--------------------------------------------------------------------------------------------------------------------------------------