# MurMurHash

An implementation of the MurMurHash3 function in C++

 MurmurHash3 was originally written by Austin Appleby and has been released into the public domain.

 The LogRhythm `C++` version was adapted from `C` code found at https://github.com/PeterScott/murmur3 .


## API
[[MurMurhash.h]] (https://github.com/LogRhythm/MurMurHash/blob/master/src/MurMurHash.h)

## BUILD
```
cd 3rdparty
unzip gtest-1.7.0.zip
mkdir build
cd build
cmake ..
make
sudo make install
```

Alternative on Debian systems after `cmake ..`
```
make package
sudo dpkg -i MurMurHash<package_version>Linux.deb
```
