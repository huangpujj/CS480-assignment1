all: scanner.cpp scanner

scanner.cpp:	
	flex -o scanner.cpp scanner.l
scanner:
	g++ -o scan scanner.cpp
clean:
	rm -f scanner.cpp
	rm -f scan

