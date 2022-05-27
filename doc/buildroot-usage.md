# BuildRoot 使用

## 简单用法

不想进行复杂配置的话可以通过几步完成：
 * 在官网下载buildroot源码包： https://buildroot.org/download.html 
 * 进行配置：`make qemu_aarch64_virt_defconfig`
 * 编译：`make` ， 编译会消耗很长时间（半小时左右）

编译buildroot的话，会下载很多源码包进行编译，下载过程也很耗时，配置环境变量 BR2_DL_DIR 可以指定所有包的下载路径。如果包已经存在就不用下载直接使用。
参考回答：https://stackoverflow.com/questions/33648114/buildroot-re-downloading-packages

在我Fedora36的系统上面，编译时缺少几个perl的包，需要根据情况安装一下。（有ExtUtils-MakeMaker Thread-Queue FindBin）

buildroot会编译大量host主机程序，用于编译guest环境，甚至包括的交叉编译器，qemu。编译好就可以直接运行。

<del>TBD ：控制不编译交叉编译器、内核, 进行更完整的配置（如 使用glibc，加入coreutils，加入systemctl）</del>


## 配置更多包

这次尝试尽可能多的配置我认为需要的包，包括 systemd， glibc， binutils， 各种压缩解压工具等等。
然后执行make进行编译，然后等待很久的下载编译之后，就生成了一个像模像样的Linx环境了，真是强大的工具。

途中需要解决网络代理的问题，这里就不赘述了。

