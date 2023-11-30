extends Object

var subscribableSignals: Array[SubscribableSignal] = []

func addSignal(source: signal):
	var sub = SubscribableSignal.new()
	sub.source = source
	subscribableSignals.append(sub)

func addListener(source, listener):
	var found = subscribableSignals.filter(func(s): return s.source == source)
	if found.length == 1:
		(found[0] as SubscribableSignal).addListener(listener)

func triggerSignal(source: Object):
	var found = subscribableSignals.filter(func(s): return s.source == source)
	if found.length == 1:
		(found[0] as SubscribableSignal).triggerListeners()
