# ============================================================================ #
#
# glibc `DT_FILTER' bug minimal example
#
#
# ============================================================================ #

.PHONY: check test all

.DEFAULT_GOAL = check

TOPDIR = $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

BINS = mainBM mainBF mainMB mainFB

CFLAGS += -ggdb3 -frecord-gcc-switches
libs_CFLAGS = -shared -fPIC
libs_LDFLAGS = $(LDFLAGS) -shared
libpath_LDFLAGS = -L$(TOPDIR) -Wl,-rpath,$(TOPDIR)


# ---------------------------------------------------------------------------- #

foo.o foo2.o foo_filt.o bar.o bar2.o: CFLAGS += $(libs_CFLAGS)


# ---------------------------------------------------------------------------- #

libfoo.so: foo.o foo2.o
	$(CC) -o $@ -Wl,-h,$@ $(libs_LDFLAGS) $^

libfoomin.so: foo_filt.o libfoo.so
	$(CC) -o $@ -Wl,-h,$@ $(libs_LDFLAGS) $(libpath_LDFLAGS) $< -Wl,-F,libfoo.so

libbar.so: bar.o bar2.o libfoomin.so
	$(CC) -o $@ -Wl,-h,$@ $(libs_LDFLAGS) $(libpath_LDFLAGS) bar.o bar2.o -lfoomin


# ---------------------------------------------------------------------------- #

mainBM: main.o libfoomin.so libbar.so
	$(CC) -o $@ $(LDFLAGS) $(libpath_LDFLAGS) $< -lbar -lfoomin

mainBF: main.o libfoo.so libbar.so
	$(CC) -o $@ $(LDFLAGS) $(libpath_LDFLAGS) $< -lbar -lfoo

mainMB: main.o libfoomin.so libbar.so
	$(CC) -o $@ $(LDFLAGS) $(libpath_LDFLAGS) $< -lfoomin -lbar

mainFB: main.o libfoo.so libbar.so
	$(CC) -o $@ $(LDFLAGS) $(libpath_LDFLAGS) $< -lfoo -lbar


# ---------------------------------------------------------------------------- #

all: $(BINS)


clean:
	-$(RM) -f $(BINS) *.o lib*.so


check: test.sh all
	@./$< && echo PASS || ( echo FAIL && exit 1 )


# ---------------------------------------------------------------------------- #


# ============================================================================ #
# end
