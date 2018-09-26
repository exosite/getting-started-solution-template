FROM java:8

RUN wget http://mirror.nbtelecom.com.br/apache/jmeter/binaries/apache-jmeter-5.0.tgz
RUN echo 'a5a3bdd84ec8f78b67cee1b12bd9f2f578f3e9334ef2dc85cebd37878e0cf69ea3385a9c4f531dae094c0a4df93f262f43c2d9a9dfb10d38565d17eec3f907f1 *apache-jmeter-5.0.tgz' > apache-jmeter-5.0.tgz.sha
RUN sha512sum -c apache-jmeter-5.0.tgz.sha
RUN echo '-----BEGIN PGP SIGNATURE-----\n\
\n\
iQIzBAABCgAdFiEExJI/mr+y8aBvCOiLrCFMqgYSs5kFAlub1bUACgkQrCFMqgYS\n\
s5ln7g/8DY2FqxOrtu6vzZJbx1WUqxDfKZFmbesvYWy45N+hZj/507gNO+S1S7Nj\n\
zmpkbF4q40rv6J15UNnGALvKCWB42txvhDu3BD7JRFMtnrwZelV+R9pfevIZ/Ow8\n\
9PiqFvrycmhxSd5g0IAO1fQxPc4OvigrpUw5lI9JiQIRIGPRjkYGyfZYnB4Ci32k\n\
TT6pt/gzzBz1I6LxNhqxZEoB7ItsQILTxf2SSDIu7lZhWAQmoOQwxy8M8F/PHhB7\n\
EfAiQWVmB2Kix63ybBalX0jSthpE+8XHSDtDKL+gggCGLThTywlY4Uxg8WOKGFy0\n\
e/aYqW0z9DT8wohJJ/3tBP5mzvratdXxr9lgzO9dln9kQCE4hc3tTPw3u5LkNDsV\n\
CTdxxfVcmhowIaCERXoi0TtKxvxUdbn06+Hm8/Z3uYxW/yMRlnJW/0vZDhT/rHji\n\
NhiYJla4OueCvQg+cQNviaUIOM9Hp5bKKcF6ifBvDxmUnuO8Be8MbWsCM2i8DBQv\n\
WgfzfF0dI44ARHHNqEnxQ5nLF2V8mbM5anmi126H9LRQqqTj7bfwtYDH9RV3vT6v\n\
OOZX0oqDBysHm6vlNV89QADlzsDbTta2fExpfYTMLdsysNFwAiGGOO4LY2HUjbQU\n\
nf4C89mvpT4IV053VSMHlkjWAcQFP8I4VFuyl+ofajaNYA7uAMs=\n\
=kurx\n\
-----END PGP SIGNATURE-----\n' > apache-jmeter-5.0.tgz.asc

RUN gpg --keyserver pgpkeys.mit.edu --recv-key C4923F9ABFB2F1A06F08E88BAC214CAA0612B399
RUN gpg --verify apache-jmeter-5.0.tgz.asc apache-jmeter-5.0.tgz

RUN tar -xvzf apache-jmeter-5.0.tgz
RUN rm apache-jmeter-5.0.tgz
RUN mv apache-jmeter-5.0 /jmeter

ENV JMETER_HOME /jmeter
ENV PATH $JMETER_HOME/bin:$PATH
