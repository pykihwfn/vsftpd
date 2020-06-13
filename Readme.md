# docker run :
```bash
docker run -d \ --name vsftpd_service\ -p 21:21\ -p 50000-50200:50000-50200\ -v /data/vsftpd_data:/home/ftpuser\ -e PASV_ADDRESS=10.1.11.80\ -e MIN_PORT=50000 \ -e MAX_PORT=50200 \ -e USER=alex \ -e PASSWORD=alex1234 \ -e DIRECTORY=bdf_test zhuxiaowei/vsftpd
```
**NOTE:
PASV_ADDRESS : docker container 宿主机的IP
MIN_PORT： 被动模式的最小端口
MAX_PORT： 被动模式的最大端口
USER： FTP登录的用户名
PASSWORD： FTP登录的密码
DIRECTORY： 用户限制的目录，默认为/home/ftpuser,如果想限制用户的根目录，例如想限制用户只能访问/home/ftpuser/www ,设置DIRECTORY=www即可.**

------------

# create ftp user
```bash
docker exec vsftpd_service bash /usr/sbin/create-user.sh username password directory
```
NOTE:
username: login ftp user name
password: password
directory: local_root #example set directory=web1 , user only chroot in /home/ftpuser/web1 directory