# Reactive Swift


An implementation of Colin Eberhardt's  [raywenderlich.com ReactiveCocoa tutorial][wenderlich] in Swift.

I've been playing around trying to get [ReactiveCocoa][reactivecocoa_github] to play nice with [Swift][swift_lang].

For more information, see my [blog post][blogpost] which goes into detail about the interop issues and workarounds.

## Installation

After cloning, you'll want to initialize the `ReactiveCocoa` submodule by doing:

```
git submodule init
git submodule update
``` 

This will check out [my fork][rc_fork] of ReactiveCocoa, which has a workaround for a Swift compiler error.

[reactivecocoa_github]: https://github.com/ReactiveCocoa/ReactiveCocoa
[wenderlich]: http://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1
[swift_lang]: https://developer.apple.com/swift/
[blogpost]: http://napora.org/a-swift-reaction
[rc_fork]: https://github.com/yusefnapora/ReactiveCocoa