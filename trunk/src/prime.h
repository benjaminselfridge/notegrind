#include <vector>

/**
 * @brief a static class devoted to maintaining a list of prime numbers
 * 
 * This really should be a namespace but I couldn't figure out how to 
 * encapsulate the methods I wanted private within a namespace.
 */
class prime {
    /**
     * @brief returns a list to the currently computed list of prime numbers.
     */
    static std::vector<int>& primes();

    /**
     * @brief checks against the computed list to see if this next number is prime.
     *
     * This is private because it only does what it says it does if isPrime(x-1)
     * has already been computed.
     */
    static bool isPrime(int x);

 public:
    /**
     * @brief gives back the nth prime, n starting at 0.
     *
     * nthPrime(0) = 2, nthPrime(3) = 7, etc.
     */
    static unsigned int nthPrime(unsigned int n);
};
