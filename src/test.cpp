#include <iostream>
#include "test.h"

void test(bool assertion, std::string failure_msg) {
    if (!assertion) {
	std::cout << failure_msg;
	//	exit(1);
    }
}
