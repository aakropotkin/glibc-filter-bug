# ============================================================================ #
#
# glibc `DT_FILTER' bug minimal example
#
#
# ============================================================================ #

.DEFAULT_GOAL: check

TOPDIR = $(dir $(firstword $(MAKEFILES_LIST)))

BINS = mainBM mainBF mainMB mainFB

libs_CFLAGS = -shared -fPIC
libs_LDFLAGS = -shared
libpath_LDFLAGS = -L$(TOPDIR) -rpath $(TOPDIR)


# ---------------------------------------------------------------------------- #

foo.o foo_filt.o bar.o: CFLAGS += $(libs_CFLAGS)


# ---------------------------------------------------------------------------- #
#
libfoo.so: foo.o
	$(LD) -o $@ -h $@ $(libs_LDFLAGS) $<

libfoomin.so: libfoo.so foo_filt.o
	$(LD) -o $@ -h $@ $(libs_LDFLAGS) $(libpath_LDFLAGS) -F $^

libbar.so: bar.o libfoomin.so
	$(LD) -o $@ -h $@ $(libs_LDFLAGS) $(libpath_LDFLAGS) $< -lfoomin


# ---------------------------------------------------------------------------- #

mainBM: main.o libfoomin.so libbar.so
	$(LD) -o $@ $(libpath_LDFLAGS) $< -lbar -lfoomin -lc

mainBF: main.o libfoo.so libbar.so
	$(LD) -o $@ $(libpath_LDFLAGS) $< -lbar -lfoo -lc

mainMB: main.o libfoomin.so libbar.so
	$(LD) -o $@ $(libpath_LDFLAGS) $< -lfoomin -lbar -lc

mainFB: main.o libfoo.so libbar.so
	$(LD) -o $@ $(libpath_LDFLAGS) $< -lfoo -lbar -lc


# ---------------------------------------------------------------------------- #

clean:
	-$(RM) -f $(BINS) *.o lib*.so

check: test.sh $(BINS)
	-./$< && echo PASS || echo FAIL


# ---------------------------------------------------------------------------- #


# ============================================================================ #
# end
