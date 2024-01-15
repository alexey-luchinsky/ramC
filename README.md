*ramC* is a C++ interface to RAMBO generator for Lorentz Invariant Phase Space integration

# Installation

*ramC* is a CMake project, so usual steps should work:

	mkdir build
	cd build
	cmake ../
	make

Note that you should have __EvtGen__ and __ROOT__ programs installed.

# Usage

As a result the library file libramC.a should be created. In addition,
a test program test.exe will also be created. It is a collection of
unit tests (I am using Cath2 library). To run it simply use

	./test.exe --use-colour no

The result should look like

	===============================================================================
	All tests passed (21 assertions in 5 test cases)

If you want to see more details of the tests, add option "-s" to the previos command.

You can also examine this program to see how the generator is used.

# File description

The project is in CMake format, so the following files are included:

	CMakeLists.txt: main CMake file
	FindEvtGen.cmake. FindHepMC.cmake, FindROOT.cmake: CMake scripts used to find the corresponding packages. Note that you should correct them according to you system
	README.md: this file
	src/:    the source directory
		rambo_.for:   the source of the original FORTRAN program
		ramC.c++, ramC.h:   C++ interface to this program
		test.c++:   test program (also can be used to see the use cases)
		catch.hpp:  template library for unit tests
	
