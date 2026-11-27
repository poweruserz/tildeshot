target_sources(tildeshot PRIVATE
    tildeshot.h
    tildeshotdaemon.h
    qguiappcurrentscreen.h
)

target_sources(tildeshot PRIVATE
    capturerequest.cpp
    tildeshot.cpp
    tildeshotdaemon.cpp
    qguiappcurrentscreen.cpp
)

if (UNIX AND NOT APPLE)
target_sources(tildeshot PRIVATE
    tildeshotdbusadapter.h
    tildeshotdbusadapter.cpp
)
endif ()

if (USE_KDSINGLEAPPLICATION)
if (NOT WIN32)
target_sources(tildeshot PRIVATE
    signaldaemon.h
    signaldaemon.cpp
)
endif ()
endif ()

if (WIN32)
    target_sources(tildeshot PRIVATE globalshortcutfilter.h globalshortcutfilter.cpp)
endif ()
