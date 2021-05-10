import java.io.*;

// this isnt technically valid java but do i care? no.

class Foobar {
    private int foo;
    private int bar;

    public int getFoo() { return this.foo; }
    public int getBar() { return this.bar; }

    // who cares about setters
}

class FooBarFactory {
    //Foobar foobar;

    // Return a new foobar or something
    public Foobar getFoobar() {
        return new Foobar();
    }
}

class Main {
    FooBarFactory factory;

    // seriously i hate this fucking language
    public void javaIsShit() {
        // i give up just work
        Foobar f = factory.getFooBar();
    }
}
