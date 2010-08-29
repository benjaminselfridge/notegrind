#include <iostream>
#include "fraction.h"
#include "prime.h"

int main(int argc, char **argv) {
    unsigned int first_twenty_primes[20] = {2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71};

    for(unsigned int i=0; i < 20; i++) {
	if (prime::nthPrime(i) != first_twenty_primes[i]) {
	    std::cout << "prime::nthPrime(i) = " << prime::nthPrime(i) << ", should be " <<
		first_twenty_primes[i] << "\n";
	    return 1;
	}
    }

    if (prime::nthPrime(24) != 97) {
	std::cout << "prime::nthPrime(24) = " << prime::nthPrime(24) << ", should be 97\n";
	return 1;
    }
    
    return 0;
}
