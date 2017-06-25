# libUSB32.so/libUSB64.so Dynamic Library for Linux

## Programming language
C++

## Dependencies
- FTDI Driver

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
