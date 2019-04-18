#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OFFSET	3

void	ft_bzero(void *s, size_t len);
char	*ft_memset(void *s, int c, size_t len);
/*
int main(int c, char *v[])
{
	char	s[1000];
	int		i = atoi(v[1]);
	int		j = atoi(v[2]);

	printf("i = %d\n\n", i);
	memset(s, '.', 1000);
	ft_memset(s, 'A', j);
	printf("s = \"%.*s\"\n", j + 3, s);
	ft_memset(s, '.', 1000);
	ft_bzero(s + OFFSET, i);
	printf("i = %d\n\n", i);
	printf("\e[0;36m");
	for (int j = 0; j < i + 20 + OFFSET; j++)
		printf("%3d ", j - OFFSET + 1);
	printf("\e[0m\n");

	for (int j = 0; j < i + 20 + OFFSET; j++)
	{
		printf("%3d ", s[j]);
	}
	printf("\n");

	return (0);
}
int	main(int argc, char *argv[])
{
	if (argc != 3)
		return (0);
	size_t	size = (size_t)atol(argv[1]);
	size_t	offset = (size_t)atol(argv[2]);
	char	*str = malloc(size + 1024 + offset);
	size_t	i;

	memset(str, '.', size + 1024 + offset);
	ft_bzero(str + offset, size);
	for (i = 0; i < offset; i++)
	{
		if (str[i] != '.')
		{
			fprintf(stderr, "(1) bzero doesn't work\n");
			exit(0);
		}
	}
	for (; i < size + offset; i++)
	{
		if (str[i] != 0)
		{
			fprintf(stderr, "(2) bzero doesn't work\n");
			exit(0);
		}
	}
	for (; i < size + offset + 1024; i++)
	{
		if (str[i] != '.')
		{
			fprintf(stderr, "(3) bzero doesn't work\n");
			exit(0);
		}
	}
	fprintf(stdout, "It's work\n");
}
*/
/* ************************************************************************** */
/*                                                          LE - /            */
/*                                                              /             */
/*   test_bzero.c                                     .::    .:/ .      .::   */
/*                                                 +:+:+   +:    +:  +:+:+    */
/*   By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+     */
/*                                                 #+#   #+    #+    #+#      */
/*   Created: 2019/04/18 09:21:33 by mhouppin     #+#   ##    ##    #+#       */
/*   Updated: 2019/04/18 09:34:42 by mhouppin    ###    #+. /#+    ###.fr     */
/*                                                         /                  */
/*                                                        /                   */
/* ************************************************************************** */

#include <sys/mman.h>
#include <stdlib.h>

void	*xalloc(size_t size)
{
	void	*ptr = mmap(NULL, size + 8192, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);

	memset(ptr, 0x55, size + 8192);
	mprotect(ptr, 4096, PROT_NONE);
	mprotect(ptr + 4096 + size, 4096, PROT_NONE);
	return (ptr + 4096);
}

int		main(void)
{
	size_t	size = 1048576ul * 1024ul;

	void	*data = xalloc(size);
	
	ft_bzero(data + 1, size - 2);
	if (((char *)data)[0] != 0x55 || ((char *)data)[size - 1] != 0x55)
	{
		fprintf(stderr, "Test failed, data modified guard block\n");
		exit(EXIT_FAILURE);
	}
	if (memchr(data + 1, 0x55, size - 2))
	{
		fprintf(stderr, "Test failed, data didn't set memory correctly\n");
		exit(EXIT_FAILURE);
	}
	fprintf(stdout, "Super !\n");
	exit(EXIT_SUCCESS);
}
