#include <errno.h>
#include <fuse.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define FILL(word) fill(buf, word, NULL, 0, 0)

void
puke_stream
(		void * buf,
		fuse_fill_dir_t fill,
		FILE * h)
{
	char line[4096];
	while (fgets(line, sizeof line, h))
	{
		int n = strlen(line);
		line[n - 1] = '\0'; // remove trailing new line
		FILL (line);
	}
}

int
ls_tags
(		void * buf,
		fuse_fill_dir_t fill)
{
	FILE *h = popen("_fuse_tags.sh", "r");
	if (!h)
		return -EIO;

	puke_stream(buf, fill, h);
	pclose(h);

	FILL ("-");
	FILL ("+");
	return 0;
}

void
ls_find_proc
(		const char * path,
		int fd1)
{
	char buf[4096];
	strncpy(buf, path, sizeof buf - 1);
	buf[sizeof buf - 1] = '\0';

#define MAX_ARGV 1023
	char *argv[MAX_ARGV + 1] = {
		"tfind.sh",
		"/ai",
	};
	int n = 2;

	char *p = &buf[1];
	while (strcmp(p, "+"))
	{
		char *t = strchr(p, '/');
		*t = '\0';

		if (strcmp(p, "-"))
		{
			argv[n] = p;
			n++;
			if (n == MAX_ARGV)
				break;

			p = &t[1];
		}
		else
		{
			p[1] = '-';
			p++;
		}
	}

	if (dup2(fd1, 1) == -1)
		return;
	close(fd1);

	execvp(argv[0], argv);
}

int
ls_find_wait
(		void * buf,
		fuse_fill_dir_t fill,
		int fd0)
{
	FILE *h = fdopen(fd0, "r");
	if (!h)
	{
		close(fd0);
		return -EIO;
	}

	puke_stream(buf, fill, h);
	fclose(h);
	return 0;
}

int
ls_find
(		const char * path,
		void * buf,
		fuse_fill_dir_t fill)
{
	int pfd[2];
	if (pipe(pfd) == -1)
		return -EIO;

	pid_t k = fork();
	if (k == -1)
		return -EIO;

	if (k == 0) // child
	{
		close(pfd[0]);
		ls_find_proc(path, pfd[1]);
		_exit(0);
	}

	close(pfd[1]);
	return ls_find_wait(buf, fill, pfd[0]);
}

int
fs_readdir
(		const char * path,
		void * buf,
		fuse_fill_dir_t fill,
		off_t off,
		struct fuse_file_info * fi,
		enum fuse_readdir_flags flags)
{
	FILL (".");
	FILL ("..");

	char *p = strrchr(path, '/');
	if (strcmp(&p[1], "+"))
		return ls_tags(buf, fill);
	else
		return ls_find(path, buf, fill);
}
