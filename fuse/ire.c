#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

// WARNING: not thread safe!
time_t g_maps;
int g_mapfd = -1;
char *g_mapfile;
char g_root[4096];
int g_rootsize;

int
open_map (void)
{
	time_t now = time(NULL);
	// Physical file may have been replaced by move
	if (now > g_maps)
	{
		if (g_mapfd != -1)
			close(g_mapfd);

		g_mapfd = open(g_mapfile, O_RDONLY);
		if (g_mapfd == -1)
			return -1;
	}

	g_maps = now;
	return g_mapfd;
}

int
map_find
(		char * buf,
		size_t len,
		long key)
{
	int fd = open_map();
	if (fd == -1)
		return -1;

	char fg[4096];
	char bg[4096];
	long nr = 1;
	int bg_n = 0;

	lseek(fd, 0, SEEK_SET);
	int n;
	do
	{
		n = read(fd, fg, sizeof fg);
		if (n == -1)
			return -1;

		int k = 0;
		int i;
		for (i = 0; i < n; ++i)
		{
			if (fg[i] != '\n')
				continue;

			if (nr == key)
			{
				n = g_rootsize;
				if (n > len - 1)
					n = len - 1;
				memcpy(buf, g_root, n);
				buf += n;
				len -= n;

				if (bg_n)
				{
					if (bg_n > len - 1)
						bg_n = len - 1;
					memcpy(buf, bg, bg_n);
					buf += bg_n;
					len -= bg_n;
				}

				n = i - k;
				if (n > len - 1)
					n = len - 1;
				memcpy(buf, &fg[k], n);
				buf[n] = '\0';
				return 0;
			}

			nr++;
			k = i + 1;
			bg_n = 0;
		}

		bg_n = n - k;
		memcpy(bg, &fg[k], bg_n);
	}
	while (n == sizeof fg);
	return 1;
}
