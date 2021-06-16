
extern int foo( int );

  int
bar( int x )
{
  return x + 3;
}


  int
baz( int x )
{
  return foo( x ) + 4;
}
