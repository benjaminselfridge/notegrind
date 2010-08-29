#include <iostream>
#include <cstdlib>
#include "fraction.h"
#include "utils.h"

int main(int argc, char **argv) {
    if (argc < 3) return 0;

    int n = atoi(argv[1]), d = atoi(argv[2]);
    std::cout << "initial: " << n << ", " << d << "\n";
    fraction f(n, d);
    std::cout << "reduced form: " << f << "\n";
    std::cout << "coordinate form: ";
    printVector(f.getCoordinates());
    std::cout << "\n";
    std::cout << "prime factorization: " << f.primeFactorization() << "\n";
    
    return 0;
}
