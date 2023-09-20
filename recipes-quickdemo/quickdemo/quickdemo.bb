SUMMARY = "QT Demo app"
DESCRIPTION = "Simple quick demo app"
LICENSE = "CLOSED"

SRC_URI = "file://CMakeLists.txt \
           file://Main.qml \
           file://demo.cpp \
           file://demo.h \
           file://main.cpp"

DEPENDS += " qtbase \
             qtdeclarative-native \
             qtquick3d"

S = "${WORKDIR}"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 appquickDemo ${D}${bindir}

    #replace default app
    ln --relative --symbolic ${D}${bindir}/appquickDemo ${D}/${bindir}/b2qt
}

FILES_${PN} = "${bindir}/appquickDemo \
               ${bindir}/b2qt \
              "

inherit qt6-cmake

