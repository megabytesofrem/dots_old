#include <iostream>

struct foo_struct 
{
	int bar;
	int baz;
};

int main(void) 
{
	struct foo_struct fs;

	// assign foobar to 21
	int foobar = 21; /* end of line comment */

	fs->bar = 2;
	fs->baz = foobar;

	/** call fromulate */
	fromulate(fs, bar, baz);

}


int fromulate(struct foo_struct fs*, int a, int b) 
{
	return a + b;
}
