#! /usr/bin/env sh

set -e;

if test ! -x ./mainBM -o ! -x ./mainBF -o ! -x ./mainMB -o ! -x ./mainFB; then
  echo "Missing executables, run \`make'!" >&2;
  exit 1;
fi

BM_EXPECT="$(( 5 + 1 )) $(( 5 + 3 )) $(( 5 + 1 + 4 ))";
BF_EXPECT="$(( 5 + 1 )) $(( 5 + 3 )) $(( 5 + 1 + 4 ))";
MB_EXPECT="$(( 5 + 1 )) $(( 5 + 3 )) $(( 5 + 1 + 4 ))";
FB_EXPECT="$(( 5 + 1 )) $(( 5 + 3 )) $(( 5 + 2 ))";

if test "$( ./mainBM; )" != "${BM_EXPECT}"; then
  echo "\`mainBM' failed to produce : '${BM_EXPECT}'" >&2;
  echo "Got : '$( ./mainBM; )'" >&2;
  exit 2;
fi

if test "$( ./mainBF; )" != "${BF_EXPECT}"; then
  echo "\`mainBF' failed to produce : '${BF_EXPECT}'" >&2;
  echo "Got : '$( ./mainBF; )'" >&2;
  exit 3;
fi

if test "$( ./mainMB; )" != "${MB_EXPECT}"; then
  echo "\`mainMB' failed to produce : '${MB_EXPECT}'" >&2;
  echo "Got : '$( ./mainMB; )'" >&2;
  exit 4;
fi

if test "$( ./mainFB; )" != "${FB_EXPECT}"; then
  echo "\`mainFB' failed to produce : '${FB_EXPECT}'" >&2;
  echo "Got : '$( ./mainFB; )'" >&2;
  exit 5;
fi

exit 0;
