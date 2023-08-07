# 'make'        build executable file 'exe'
# 'make clean'  removes all .o and executable files
#

USE_C = 0

ifeq ($(USE_C), 1)
CC = gcc-12
SRCS = $(wildcard ./sources/*.c)
OBJS = $(SRCS:.c=.o)
TEST_SRCS = $(wildcard ./tests/Test_*.c ./sources/*.c)
TEST_SRCS := $(filter-out ./sources/main.c, $(TEST_SRCS))
TEST_OBJS = $(TEST_SRCS:.cpp=.o)
CFLAGS = -Wall -Werror -O3 -fPIC -g
TEST_CFLAGS = --coverage
.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@
else
CC = g++-12
SRCS = $(wildcard ./sources/*.cpp)
OBJS = $(SRCS:.cpp=.o)
CFLAGS = -Wall -Werror -O3 -fPIC -std=c++20 -g
TEST_SRCS = $(wildcard ./tests/Test_*.cpp ./sources/*.cpp)
TEST_SRCS := $(filter-out ./sources/main.cpp, $(TEST_SRCS))
TEST_OBJS = $(TEST_SRCS:.cpp=.o)
TEST_CFLAGS = --coverage -fno-elide-constructors
.cpp.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@
endif

# define any directories containing header files other than /usr/include
#
INCLUDES = -I./headers
TEST_INCLUDES = -I/usr/local/include/gtest/

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib I'd specify
#   their path using -Lpath, something like:
LFLAGS = -L./libs

# define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname
#   option, something like (this will link in libmylib.so and libm.so:
LIBS = -lncurses -lgmp -lgmpxx -lfmt
TEST_LIBS = -lgtest -lgcov

# Linker flags
LDFLAGS =
TEST_LDFLAGS = -fprofile-arcs -ftest-coverage --coverage

# define the executable file
MAIN = exe
TEST = exe_test

.PHONY: all clean test

all:    $(MAIN)
	@echo $(MAIN) has been compiled

$(MAIN): $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS) $(LDFLAGS)

clean:
	$(RM) ./sources/*.o ./sources/*.gcno ./sources/*.gcda *~ $(MAIN)
	$(RM) ./tests/*.o ./tests/*.gcno ./tests/*.gcda *~ $(TEST)

test:    $(TEST)
	@echo $(TEST) has been compiled

$(TEST): $(TEST_OBJS)
	$(CC) $(CFLAGS) $(TEST_CFLAGS) $(INCLUDES) $(TEST_INCLUDES) -o $(TEST) $(TEST_OBJS) $(LFLAGS) $(LIBS) $(TEST_LIBS) $(LDFLAGS) $(TEST_LDFLAGS)
