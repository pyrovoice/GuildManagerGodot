extends Object
class_name SubscribableSignal

var source
var listeners: Array = []

func init(source):
	pass
	
func addListener(o: Object):
	listeners.append(o)
	pass

func triggerListeners():
	for l in listeners:
		l.trigger(self)
	pass
	
func removeListener(listener):
	pass
