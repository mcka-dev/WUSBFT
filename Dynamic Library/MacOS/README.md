# libUSB32.dylib/libUSB64.dylib Dynamic Library for MacOS

## Programming language
C++

## Dependencies
- FTDI D2XX Driver

## Building Project
g++

### Compile a 64-bit Dynamic Library 

#### include libftd2xx.so
```bash
make build-x64
```

#### without libftd2xx.so
```bash
make build-x64-without-ftd2xx
```

### Compile a 32-bit Dynamic Library 

#### include libftd2xx.so
```bash
make build-x86
```

#### without libftd2xx.so
```bash
make build-x86-without-ftd2xx
```
