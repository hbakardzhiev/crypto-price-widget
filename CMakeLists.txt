cmake_minimum_required(VERSION 3.10)
project(MyFltkX11App)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Find FLTK for X11
find_package(FLTK REQUIRED NO_MODULE)
if(FLTK_FOUND)
    message(STATUS "FLTK found with version: ${FLTK_VERSION}")
else()
    message(FATAL_ERROR "FLTK not found")
endif()


# Add source files
add_executable(${PROJECT_NAME} app/main.cpp)

# Link FLTK dynamically with X11
target_link_libraries(${PROJECT_NAME} 
    fltk
    ${X11_LIBRARIES}
)

# Include FLTK and X11 headers
target_include_directories(${PROJECT_NAME} PRIVATE 
    ${FLTK_INCLUDE_DIRS}
    ${X11_INCLUDE_DIR}
)

# Compiler flags
target_compile_options(${PROJECT_NAME} PRIVATE 
    -Wall 
    -Wextra
)

# Define that we want to use the X11 backend for FLTK
target_compile_definitions(${PROJECT_NAME} PRIVATE _FLTK_BACKEND_X11)
