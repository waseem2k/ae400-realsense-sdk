# Remove src because we link to prebuilt backend-ethernet lib
set(REMOVE_CPP
    ../../src/linux/backend-v4l2.cpp
    ../../src/linux/backend-hid.cpp
    ../../src/win/win-uvc.cpp
    ../../src/win/win-usb.cpp
    ../../src/win/win-hid.cpp
    ../../src/win/win-backend.cpp
)
set(REMOVE_HPP
    ../../src/linux/backend-v4l2.h
    ../../src/linux/backend-hid.h
)
# after RS2 API 2.22, backend WMF_BACKEND requires win-helpers.cpp
if(${REALSENSE_VERSION_STRING} VERSION_LESS 2.22)
    list(APPEND REMOVE_CPP
            ../../src/win/win-helpers.cpp
        )
    endif()
# another approach...
#if(${REALSENSE_VERSION_STRING} VERSION_GREATER 2.21)
#    if((${BACKEND} STREQUAL RS2_USE_WMF_BACKEND))
#        list(REMOVE_ITEM REMOVE_CPP
#            ../../src/win/win-helpers.cpp
#        )
#    endif()
#endif()

if(DEFINED RAW_RS_CPP)
    list(REMOVE_ITEM RAW_RS_CPP ${REMOVE_CPP})
endif()
if(DEFINED RAW_RS_HPP)
    list(REMOVE_ITEM RAW_RS_HPP ${REMOVE_HPP})
endif()
if(DEFINED RS_CPP)
    list(REMOVE_ITEM RS_CPP ${REMOVE_CPP} ${REMOVE_HPP})
endif()

if(TARGET pybackend2)

if(USE_EXTERNAL_USB)
    include_directories(pybackend2 ${LIBUSB_LOCAL_INCLUDE_PATH})
endif()

target_link_libraries(pybackend2 PRIVATE backend-ethernet)

get_target_property(PYBIND_SRC pybackend2 SOURCES)

list(REMOVE_ITEM PYBIND_SRC ${REMOVE_CPP} ${REMOVE_HPP})

set_target_properties(pybackend2 PROPERTIES
    SOURCES "${PYBIND_SRC}"
)

endif()
