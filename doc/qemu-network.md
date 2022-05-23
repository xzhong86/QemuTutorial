# QEMU Network 使用

## 入门用法：端口转发

回答链接： https://unix.stackexchange.com/questions/124681/how-to-ssh-from-host-to-guest-using-qemu

简单方法完成ssh port forward： `-net user,hostfwd=tcp::10022-:22 -net nic`
ssh连接： `ssh user@localhost -p 10022`

回答中解释需要 ‘-net nic’ 初始化最基础的网卡接口。

## 进阶用法：构建网络

TBD
