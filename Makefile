# **************************************************************************** #
#                                                           LE - /             #
#                                                               /              #
#    Makefile                                         .::    .:/ .      .::    #
#                                                  +:+:+   +:    +:  +:+:+     #
#    By: mhouppin <marvin@le-101.fr>                +:+   +:    +:    +:+      #
#                                                  #+#   #+    #+    #+#       #
#    Created: 2019/02/25 16:43:57 by mhouppin     #+#   ##    ##    #+#        #
#    Updated: 2019/04/18 10:59:47 by mhouppin    ###    #+. /#+    ###.fr      #
#                                                          /                   #
#                                                         /                    #
# **************************************************************************** #

NAME		:=libasm.so
SOURCES 	:=$(wildcard src/*.s)
OBJECTS 	:=$(SOURCES:src/%.s=obj/%.o)

all: $(NAME)

$(NAME): obj/ $(OBJECTS)

libasm.so:
	gcc -shared $(FLAGS) -o $@ $(OBJECTS)

obj/:
	mkdir -p obj

obj/%.o: src/%.s
	nasm -fmacho64 -o $@ $<

clean:
	rm -rf obj

fclean: clean
	rm -f $(NAME)

re: fclean all

PHONY: all clean fclean re
