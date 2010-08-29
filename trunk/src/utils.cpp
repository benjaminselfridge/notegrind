#include "utils.h"
#include <iostream>

void printVector(std::vector<int> vec) {
    if (vec.size() == 0) {
	std::cout << "()";
	return;
    }
    
    std::cout << "(";
    for(unsigned int i=0; i < vec.size()-1; i++) std::cout << vec[i] << ",";
    std::cout << vec[vec.size()-1] << ")";
}
