#include <iostream>
#include <cpr/cpr.h>

int main() {
    auto response = cpr::Get(
            cpr::Url {"http://www.httpbin.org/headers"},
            cpr::Header {{"accept", "application/json"}});
    std::cout << response.text << std::endl;

    return 0;
}
