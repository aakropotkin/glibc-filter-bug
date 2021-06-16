
#include <stdio.h>

extern int foo( int );
extern int bar( int );
extern int baz( int );


  int
main( int argc, char * argv[], char ** envp )
{
  int x = 5;
  if ( ( 1 < argc ) && ( argv[1][0] == '-' ) && ( argv[1][1] == 'v' ) )
    {
        printf( "foo( %d ) = %d\n", x, foo( x ) );
        printf( "bar( %d ) = %d\n", x, bar( x ) );
        printf( "baz( %d ) = %d\n", x, baz( x ) );
    }
  else
    {
      printf( "%d %d %d\n", foo( x ), bar( x ), baz( x ) );
    }
  return 0;
}
