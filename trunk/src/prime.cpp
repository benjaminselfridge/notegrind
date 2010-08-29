#include "prime.h"
#include <vector>
#include <iostream>

std::vector<int>& prime::primes() {
    static std::vector<int> primes;
    return primes;
}

bool prime::isPrime(int n) {
    if (n < 2) return false;

    for (unsigned int i=0; i < primes().size(); i++) {
	int p = primes()[i];
	if (p == n) return true;
	if (n % p == 0) return false;
    }

    return true;
}

unsigned int prime::nthPrime(unsigned int n) {
    if (primes().size() == 0) primes().push_back(2);
	
    if (n >= primes().size()) {
	int m = primes()[primes().size()-1] + 1;
	while (primes().size() <= n) {
	    if (isPrime(m)) {
		primes().push_back(m);
	    }
	    ++m;
	}
    } 

    return primes()[n];
}
