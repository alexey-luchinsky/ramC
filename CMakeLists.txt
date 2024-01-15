##Test
MESSAGE("Hello, world")
IF(DEFINED APPLE)
    MESSAGE("APPLE")
ENDIF(DEFINED APPLE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

set(CMAKE_OSX_DEPLOYMENT_TARGET "")
INCLUDE(SetCompileFlag.cmake)

cmake_minimum_required(VERSION 2.6)
project(directPsi CXX Fortran)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/build)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

## include CERN ROOT
include(FindROOT.cmake)
MESSAGE(${ROOT_LIBRARIES})
include(FindEvtGen.cmake)
include(FindHepMC.cmake)


## set fortran flags
SET_COMPILE_FLAG(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}"
                 Fortran "-fno-automatic")



include_directories(~/local/include)


include_directories(src)
include_directories(${ROOT_INCLUDE_DIR})
include_directories(${EVTGEN_INCLUDE_DIR})

include_directories(./)
include_directories(src/)

# ramC library
add_library(ramC STATIC "src/ramC.c++" "src/rambo_.for")
target_link_libraries(ramC ${ROOT_LIBRARIES} ${EVTGEN_LIBRARY_DIR}/libEvtGen.a ${HEPMC_LIBRARY_DIR}/libHepMC3.dylib) 


#adding sources for test.exe
add_executable (test.exe "src/test.c++")
target_link_libraries(test.exe ramC)
