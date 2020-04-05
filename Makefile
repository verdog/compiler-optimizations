all:
	make full -C antlr

clean:
	make clean -C antlr
	rm -rf output
