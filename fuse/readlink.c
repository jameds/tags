#include <errno.h>
#include <stdlib.h>
#include <string.h>

int map_find
(		char * buf,
		size_t len,
		long key);

int
fs_readlink
(		const char * path,
		char * buf,
		size_t len)
{
	char *p = strrchr(path, '/');
	long id = atol(&p[1]);
	switch (map_find(buf, len, id))
	{
		case 0:
			return 0;

		case -1:
			return -EIO;
	}
	return -ENOENT;
}
