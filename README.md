unoserver docker 镜像
===

基于 ubuntu 24.04 LTS。

鸣谢：

- [unoserver](https://github.com/unoconv/unoserver)
- [unoserver-docker](https://github.com/unoconv/unoserver-docker)
- [convert-document](https://github.com/occrp-attic/convert-document)

部署
---

本地部署直接使用项目中的 docker-compose 文件启动服务。

```shell
docker compose up -d
```

如果是远程部署（客户端和服务端不在同一台机器上），由于 unoserver 没有任何访问控制措施，需要您自己确保访问安全。


使用
---

客户端 SDK 为本项目中的 `client.py`，此文件是 [`unoserver.client`](https://github.com/unoconv/unoserver/blob/master/src/unoserver/client.py) 的一份复制，但是去除了 `pyuno` 的依赖。


测试：

```shell
python client.py --host-location remote example.docx example.pdf
```

在代码中使用：

```python
from .client import UnoClient

client = UnoClient(host_location="remote")
client.convert(inpath="example.docx", outpath="example.pdf")
```

定制化
---

1. 如果您发现缺失某种字体，请自行将需要的字体放到`./fonts`目录下，本项目中内置的字体包含：
    - Arial
    - Times New Roman
    - 微软雅黑
    - 宋体
    - 黑体
    - 等线
