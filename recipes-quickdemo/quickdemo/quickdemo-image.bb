DESCRIPTION = "Custom image based on b2qt-embedded-qt6-image with My Qt Application"
LICENSE = "MIT"

require recipes-qt/images/b2qt-embedded-qt6-image.bb

IMAGE_INSTALL += "quickdemo"
