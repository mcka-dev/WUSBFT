C_FLAGS = -Wall -Werror -lobjc -framework IOKit -framework CoreFoundation
DYNAMIC_LINK_OPTIONS := -rdynamic -lftd2xx -Wl,-rpath /usr/local/lib
MIN_SIZE_OPTIONS := -flto -Os
JAVA_INCLUDE_OPTIONS := -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers/

default: build64-jni

build64: clean
	@echo "build64:"
	g++ $(C_FLAGS) -shared -fPIC WUSB.cpp -o ./Release/x64/libWUSB64.dylib $(MIN_SIZE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build64-jni: clean
	@echo "build64-jni:"
	g++ $(C_FLAGS) -shared -fPIC com_krasutski_jni_WUSB.cpp WUSB.cpp -rdynamic -lftd2xx -o ./Release/x64/libWUSB64.dylib $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build64-ftd2xx-jni: check-env clean
	@echo "build64-ftd2xx-jni:"
	g++ $(C_FLAGS) -shared -fPIC com_krasutski_jni_WUSB.cpp WUSB.cpp ./Lib/x64/libftd2xx.a -o ./Release/x64/libWUSB64.dylib $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS)

build86: clean
	@echo "build86:"
	g++ $(C_FLAGS) -shared WUSB.cpp -o ./Release/x86/libWUSB32.dylib $(MIN_SIZE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build86-jni: clean
	@echo "build86-jni:"
	g++ $(C_FLAGS) -shared com_krasutski_jni_WUSB.cpp WUSB.cpp -o ./Release/x86/libWUSB32.dylib $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build86-ftd2xx-jni: clean
	@echo "build86-ftd2xx-jni:"
	g++ $(C_FLAGS) -shared com_krasutski_jni_WUSB.cpp WUSB.cpp ./Lib/x86/libftd2xx.a -o ./Release/x86/libWUSB32.dylib $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS)

clean:
	@echo "clean:"
	rm -f ./Release/x64/*.dylib ./Release/x86/*.dylib

check-env:
	@echo "JAVA_HOME=$(JAVA_HOME)"
ifndef JAVA_HOME
	$(error JAVA_HOME is undefined. Use 'export JAVA_HOME=/path/to/java_jdk')
endif
