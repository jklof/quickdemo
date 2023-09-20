This README file contains information on the contents of the quickdemo layer.

Just some doodling with qt, yocto and hf

To build on pc/mac use Qt Creator
=================================
https://www.qt.io/download-qt-installer-oss

Misc
====
How to get huggingface API key (to make captioning work):
https://huggingface.co/docs/api-inference/quicktour

Build with bitbake layers
=========================

depends on boot2qt
https://doc.qt.io/Boot2Qt-5.15/qtee-custom-embedded-linux-image.html

Run 'bitbake-layers add-layer <path to quickdemo>'
bitbake quickdemo
bitbake quickdemo-image
