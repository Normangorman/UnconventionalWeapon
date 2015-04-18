# How we're organising the game

## Interface of a game object 

Any game object must have a .assert class method that any other function can call with an object
as an argument to check that that object is a valid instance of that class.

e.g., to check baz is a valid Foo instance, call Foo.assert(baz)

The method should call assert internally, and so should crash with a helpful method on error.


The behaviours of a game object may vary, and so what interfaces a particular class implements 
should be documented in comments at the top of that class file. 

Most functionality should be used directly from Object, like so:

Player.draw = Object.draw


Tab size: 2 spaces
Use vel and pos, not velocity and position.
