#include <fuse.h>
#include <string.h>
#include <sys/stat.h>

int
fs_getattr
(		const char * path,
		struct stat * st,
		struct fuse_file_info * fi)
{
	memset(st, 0, sizeof *st);

	char *p = strrchr(path, '/');
	int tf = p - path > 1 && !memcmp(&p[-2], "/+", 2);
	st->st_mode = tf ? S_IFLNK : S_IFDIR;
	return 0;
}
