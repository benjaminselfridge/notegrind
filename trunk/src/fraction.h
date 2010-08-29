#ifndef _FRACTION_H
#define _FRACTION_H

#include <vector>
#include <iostream>
#include <string>

/**
 * @brief An immutable, nonnegative fraction class.
 *
 * In particular, this class provides the representation of a fraction in an
 * infinite-dimensional coordinate system whose axes each represent the power
 * of a prime (starting at 2) present in the fraction. Hence, the fraction
 * 10/3 is represented by (1,-1,1), representing 2^1 * 3^-1 * 5^1.
 */
class fraction {

    int numerator, denominator;
    std::vector<int> coords;

 public:
    
    /**
     * @brief construct a new fraction with the given numerator and denominator.
     *
     * @param n numerator
     * @param n denominator
     */
    fraction(int n, int d);

    /**
     * @brief get the (pre-computed) vector of coordinates that represent this
     * fraction.
     *
     * @return coordinates
     */
    std::vector<int> getCoordinates();

    /**
     * @brief get the numerator of the fraction
     *
     * @return numerator
     */
    int getNumerator() { return numerator; }
    /**
     * @brief get the denominator of the fraction
     *
     * @return denominator
     */
    int getDenominator() {return denominator; }

    /**
     * @brief get a string that shows the prime factorization of the fraction
     *
     * @return string of prime factorization
     */
    std::string primeFactorization();

    // Operators
    friend std::ostream& operator <<(std::ostream& out, const fraction& f);

};

#endif
