This README file contains information on the contents of the meta-quickdemo layer.

Just some doodling with qt, yocto and hf

qt creator
https://www.qt.io/download-qt-installer-oss

How to get huggingface API key (to make captioning work)

https://huggingface.co/docs/api-inference/quicktour

Dependencies
============
depends on boot2qt

https://doc.qt.io/Boot2Qt-5.15/qtee-custom-embedded-linux-image.html


Table of Contents
=================

  I. Adding the meta-quickdemo layer to your build
 II. Misc


I. Adding the meta-quickdemo layer to your build
=================================================

Run 'bitbake-layers add-layer <path to quickdemo>'

II. Misc
========

bitbake quickdemo

bitbake quickdemo-image
