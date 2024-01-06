#include <fuse.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int fs_getattr
(		const char*,
		struct stat*,
		struct fuse_file_info*);

int fs_readdir
(		const char*,
		void*,
		fuse_fill_dir_t,
		off_t,
		struct fuse_file_info*,
		enum fuse_readdir_flags);

int fs_readlink
(		const char * path,
		char * buf,
		size_t len);

const struct fuse_operations g_opt = {
	.getattr = fs_getattr,
	.readdir = fs_readdir,
	.readlink = fs_readlink,
};

extern char *g_mapfile;
extern char g_root[4096];
extern int g_rootsize;

int
cache_names (void)
{
	char *TAG_HOME = getenv("TAG_HOME");
	if (!TAG_HOME)
		return 1;

	g_mapfile = malloc(strlen(TAG_HOME) + 8);
	if (!g_mapfile)
		return 1;

	strcpy(g_mapfile, TAG_HOME);
	strcat(g_mapfile, "/map");

	FILE *h = popen("_get.sh root", "r");
	if (!h)
		return 1;

	if (!fgets(g_root, sizeof g_root - 1, h))
	{
		pclose(h);
		return 0;
	}

	g_rootsize = strlen(g_root);
	g_root[g_rootsize - 1] = '/';
	pclose(h);
	return 0;
}

int
main
(		int ac,
		char ** av)
{
	if (cache_names())
		return 1;
	return fuse_main(ac, av, &g_opt, NULL);
}
