C_FLAGS = -Wall -Werror
DYNAMIC_LINK_OPTIONS := -rdynamic -lftd2xx -Wl,-rpath /usr/local/lib
MIN_SIZE_OPTIONS := -flto -Os -s -nostdlib
JAVA_INCLUDE_OPTIONS := -I${JAVA_HOME}/include -I${JAVA_HOME}/include/linux

default: build64-jni

build64: clean
	@echo "build64:"
	g++ $(C_FLAGS) -shared -fPIC WUSB.cpp -o ./Release/x64/libWUSB64.so $(MIN_SIZE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build64-jni: check-env clean
	@echo "build64-jni:"
	g++ $(C_FLAGS) -shared -fPIC com_krasutski_jni_WUSB.cpp WUSB.cpp -rdynamic -lftd2xx -o ./Release/x64/libWUSB64.so $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build64-ftd2xx-jni: check-env clean
	@echo "build64-ftd2xx-jni:"
	g++ $(C_FLAGS) -shared -fPIC com_krasutski_jni_WUSB.cpp WUSB.cpp ./Lib/x64/libftd2xx.a -o ./Release/x64/libWUSB64.so $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS)

build86: clean
	@echo "build86:"
	g++ $(C_FLAGS) -shared WUSB.cpp -o ./Release/x86/libWUSB32.so $(MIN_SIZE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build86-jni: check-env clean
	@echo "build86-jni:"
	g++ $(C_FLAGS) -shared com_krasutski_jni_WUSB.cpp WUSB.cpp -o ./Release/x86/libWUSB32.so $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS) $(DYNAMIC_LINK_OPTIONS)

build86-ftd2xx-jni: check-env clean
	@echo "build86-ftd2xx-jni:"
	g++ $(C_FLAGS) -shared com_krasutski_jni_WUSB.cpp WUSB.cpp ./Lib/x86/libftd2xx.a -o ./Release/x86/libWUSB32.so $(MIN_SIZE_OPTIONS) $(JAVA_INCLUDE_OPTIONS)

clean:
	@echo "clean:"
	rm -f ./Release/x64/*.so ./Release/x86/*.so

check-env:
	@echo "JAVA_HOME=$(JAVA_HOME)"
ifndef JAVA_HOME
	$(error JAVA_HOME is undefined. Use 'export JAVA_HOME=/path/to/java_jdk')
endif
