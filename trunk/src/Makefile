all: notegrind

check: testprime testfraction
	./testprime
	./testfraction
	@echo "*** ALL TESTS PASSED ***"

notegrind: main.o fraction.o prime.o utils.o
	$(CC) $(LDFLAGS) -o notegrind main.o fraction.o prime.o utils.o

main.o: main.cpp fraction.h
	$(CC) $(CPPFLAGS) $(CXXFLAGS) -c -o main.o main.cpp

fraction.o: fraction.h fraction.cpp
	$(CC) $(CPPFLAGS) $(CXXFLAGS) -c -o fraction.o fraction.cpp

prime.o: prime.h prime.cpp
	$(CC) $(CPPFLAGS) $(CXXFLAGS) -c -o prime.o prime.cpp

utils.o: utils.h utils.cpp
	$(CC) $(CPPFLAGS) $(CXXFLAGS) -c -o utils.o utils.cpp

# Unit tests

testprime: prime.o testprime.o test.o
	$(CC) $(LDFLAGS) -o testprime prime.o testprime.o test.o

testfraction: fraction.o testfraction.o utils.o test.o prime.o
	$(CC) $(LDFLAGS) -o testfraction fraction.o testfraction.o utils.o test.o prime.o

test.o: test.h test.cpp
	$(CC) $(CPPFLAGS) $(CXXFLAGS) -c -o test.o test.cpp

testprime.o: prime.h testprime.cpp
	$(CC) $(CPPFLAGS) $(CXXFLAGS) -c -o testprime.o testprime.cpp

testfraction.o: fraction.h utils.h testfraction.cpp
	$(CC) $(CPPFLAGS) $(CXXFLAGS) -c -o testfraction.o testfraction.cpp

clean: 
	-rm *.o
	-rm notegrind
	-rm testprime
	-rm testfraction