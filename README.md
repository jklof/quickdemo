This README file contains information on the contents of the quickdemo layer.

Just some doodling with qt, yocto and hf

To build on pc/mac use Qt Creator
=================================
https://www.qt.io/download-qt-installer-oss

Build with bitbake layers
=========================

depends on boot2qt
https://doc.qt.io/Boot2Qt-5.15/qtee-custom-embedded-linux-image.html

to add layer:

`bitbake-layers add-layer <path to quickdemo>`

build an image that boots to the demo:

`bitbake quickdemo-image`


Misc
====
How to get huggingface API key (to make captioning work):
https://huggingface.co/docs/api-inference/quicktour
