#include <iostream>
#include <string>
#include <sstream>
#include "fraction.h"
#include "prime.h"

fraction::fraction(int n, int d) :
    numerator(n),
    denominator(d) {

    for(int i=0; numerator != 1 || denominator != 1; i++) {
	coords.push_back(0);
	int p = prime::nthPrime(i);
	while (numerator % p == 0) {
	    coords[i]++;
	    numerator /= p;
	}
	while (denominator % p == 0) {
	    coords[i]--;
	    denominator /= p;
	}
    }

    for(unsigned int i=0; i < coords.size(); i++) {
	for(int j=0; j < coords[i]; j++) {
	    numerator *= prime::nthPrime(i);
	}
	for(int j=0; j > coords[i]; j--) {
	    denominator *= prime::nthPrime(i);
	}
    }
}

std::vector<int> fraction::getCoordinates() {
    return coords;
}

std::string fraction::primeFactorization() {
    std::stringstream ss;
    for (unsigned int i=0; i < coords.size()-1; i++) {
	if (coords[i] != 0) {
	    ss << prime::nthPrime(i) << "^" << coords[i] << " ";
	}
    }
    if (coords[coords.size()-1] != 0) {
	ss << prime::nthPrime(coords.size()-1) << "^" << coords[coords.size()-1];
    }
    return ss.str();
}

std::ostream& operator <<(std::ostream& out, const fraction& f) {
    out << f.numerator << "/" << f.denominator;
    return out;
}
