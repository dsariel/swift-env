import pickle
import pprint
pprint.pprint( pickle.load(open('/etc/swift/object.builder')))
pprint.pprint( pickle.load(open('/etc/swift/container.builder')))
pprint.pprint( pickle.load(open('/etc/swift/account.builder')))

