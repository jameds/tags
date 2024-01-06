c=main.c getattr.c readdir.c readlink.c ire.c

CFLAGS!=pkg-config --cflags fuse3
LDLIBS!=pkg-config --libs fuse3

CFLAGS+=-DFUSE_USE_VERSION=30 -g

tfs: $(c:%.c=.build/%.o)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

include $(c:%.c=.build/%.d)

.build/%.d: %.c Makefile
	$(CC) $(CFLAGS) -M -MT .build/$*.o $< > $@

.build/%.o: %.c Makefile
	$(CC) $(CFLAGS) -o $@ -c $<
