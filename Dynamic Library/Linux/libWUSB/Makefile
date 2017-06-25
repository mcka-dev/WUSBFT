build-x64:
	g++ -Wall -fPIC -shared libWUSB.cpp ./Lib/x86-64/libftd2xx.a -o ./Release/x64/libWUSB64.so -flto -Os -s -nostdlib 

build-x64-without-ftd2xx:
	g++ -Wall -fPIC -shared libWUSB.cpp -rdynamic -lftd2xx -o ./Release/x64/libWUSB64.so -flto -Os -s -nostdlib
	
build-x86:
	g++ -Wall -shared libWUSB.cpp ./Lib/x86/libftd2xx.a -o ./Release/x86/libWUSB32.so -flto -Os -s -nostdlib 

build-x86-without-ftd2xx:
	g++ -Wall -shared libWUSB.cpp -rdynamic -lftd2xx -o ./Release/x86/libWUSB32.so -flto -Os -s -nostdlib 

clean:
	rm -f  ./Release/*.so