import swift.common.memcached as memcached

memcache = memcached.MemcacheRing(['127.0.0.1:11211'])
auth_token = memcache.get('AUTH_/user/myaccount:me')
print auth_token
print memcache.get('AUTH_/token/' auth_token)


