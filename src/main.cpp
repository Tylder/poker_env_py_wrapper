#include <iostream>

#include <pybind11/pybind11.h>
#include <pybind11/operators.h>
#include <pybind11/stl.h>
#include <pybind11/complex.h>
#include <pybind11/chrono.h>
#include <pybind11/functional.h>
#include <pybind11/numpy.h>

#define STRINGIFY(x) #x
#define MACRO_STRINGIFY(x) STRINGIFY(x)

int add(int i, int j) {
    return i + j;
}

namespace py = pybind11;

PYBIND11_MODULE(poker_env, m) {
    m.doc() = R"pbdoc(
        PokerEnv Python Wrapper
        -----------------------
        .. currentmodule:: poker_env
        .. autosummary::
           :toctree: _generate

    )pbdoc";

    py::class_<Hand>(m, "Hand")
            .def(py::init())
            .def(py::init<const Hand &>())
            .def(py::init<unsigned>())
            .def(py::init<std::array<uint8_t, 2>>())

            .def(py::self + py::self)
            .def(py::self += py::self)
            .def(py::self - py::self)
            .def(py::self -= py::self)
            .def(py::self == py::self)

            .def_static("empty", &Hand::empty)
            .def("suit_count", &Hand::suitCount, py::arg("suit"))
            .def("count", &Hand::count)
            .def("has_flush", &Hand::hasFlush)
            .def("rank_key", &Hand::rankKey)
            .def("flush_key", &Hand::flushKey);

#ifdef VERSION_INFO
    m.attr("__version__") = MACRO_STRINGIFY(VERSION_INFO);
#else
    m.attr("__version__") = "dev";
#endif
}
