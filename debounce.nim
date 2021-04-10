import times, sugar
proc debounce(call: proc, delay = 250): proc =
    var lastCall = now()
    result = proc() =
        if inMilliseconds(now() - lastCall) > delay:
            lastCall = now()
            call()
var slow = debounce(() => echo "test")
while true:
    slow()
