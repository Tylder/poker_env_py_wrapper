cmake_minimum_required(VERSION 3.4...3.18)
project(poker_env_py)

add_subdirectory(extern/PokerEnv)
add_subdirectory(pybind11 REQUIRED)

pybind11_add_module(poker_env src/main.cpp)


# EXAMPLE_VERSION_INFO is defined by setup.py and passed into the C++ code as a
# define (VERSION_INFO) here.
target_compile_definitions(poker_env
                           PRIVATE VERSION_INFO=${EXAMPLE_VERSION_INFO})
