#include "fraction.h"
#include "utils.h"
#include <iostream>

int main(int argc, char **argv) {

    fraction f(280, 135);
    std::vector<int> v;
    v.push_back(3); // 2
    v.push_back(-3); // 3
    v.push_back(0); // 5
    v.push_back(1); // 7
    
    std::vector<int> coords = f.getCoordinates();
    if (coords != v) {
	std::cout << "280/135 yielded ";
	printVector(coords);
	std::cout << ", should have been ";
	printVector(v);
	std::cout << "\n";
	return 1;
    }

    return 0;
}
