RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd && mkdir -p mkdir/root/.ssh/

// 修改root密码，便于远程登录
RUN echo root:123456 | chpasswd

// key生成
RUN ssh-keygen -t rsa
// 或者 将key生成在指定文件内
RUN ssh-keygen -q -t rsa -b 2048  -f /etc/ssh/ssh_host_rsa_key -P '' -N ''

// 配置ssh可以使用root登陆
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

// 自动启动
RUN sed -i '$i /etc/init.d/ssh start' /etc/rc.local

// 开放22端口
EXPOSE 22
