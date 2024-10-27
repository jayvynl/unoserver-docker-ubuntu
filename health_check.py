from xmlrpc.client import ServerProxy

with ServerProxy(f"http://127.0.0.1:2003", allow_none=True) as proxy:
    proxy.info()
