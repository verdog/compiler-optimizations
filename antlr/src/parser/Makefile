all: parser

SRC_FILES = $(wildcard ./*.cpp)
OBJ_FILES = $(patsubst ./%.cpp,./%.o,$(SRC_FILES))

parser:
	java -jar ../../lib/antlr-4.7.2-complete.jar -visitor -listener -Dlanguage=Cpp iloc.g4

./%.o: ./%.cpp
	g++ -g -c -I../../lib/antlr4-runtime/src/ -o $@ $<

lib: parser $(OBJ_FILES)
	mkdir -p libantlr
	cd libantlr && ar -x ../../../lib/antlr4-runtime/libantlr4-runtime.a
	ar ru libilocparser.a *.o libantlr/*.o
	ranlib libilocparser.a

clean:
	rm -f *.o *.cpp *.h libilocparser.a libantlr/*.o
