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

void	ft_bzero(void *data, size_t size);

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
	exit(EXIT_SUCCESS);
}
