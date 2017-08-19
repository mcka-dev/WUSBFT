#include <jni.h>

#include "com_krasutski_jni_WUSB.h"
#include "WUSB.h"

jfieldID getField(JNIEnv *env, jobject obj, const char *field, const char *sig) {
	return env->GetFieldID(env->GetObjectClass(obj), field, sig);
}

jmethodID getMethod(JNIEnv *env, jobject obj, const char *method, const char *sig) {
	return env->GetMethodID(env->GetObjectClass(obj), method, sig);
}

int getIntFromJObject(JNIEnv *env, jobject obj) {
	return env->GetIntField(obj, getField(env, obj, "value", "I"));
}

void setJObjectFromInt(JNIEnv *env, jobject obj, jint value) {
	env->SetIntField(obj, getField(env, obj, "value", "I"), value);
}

int getByteFromJObject(JNIEnv *env, jobject obj) {
	return env->GetIntField(obj, getField(env, obj, "value", "B"));
}

void setJObjectFromByte(JNIEnv *env, jobject obj, jbyte value) {
	env->SetIntField(obj, getField(env, obj, "value", "B"), value);
}

void callObjectMethod(JNIEnv *env, jobject obj, const char *method, const char *sig, int value) {
	env->CallObjectMethod(obj, getMethod(env, obj, method, sig), value);
}

JNIEXPORT jboolean JNICALL Java_com_krasutski_jni_WUSB_AccessUSB
(JNIEnv *env, jobject obj, jint DevNum) {
	return AccessUSB(DevNum);
}

JNIEXPORT jboolean JNICALL Java_com_krasutski_jni_WUSB_OpenUSB
(JNIEnv *env, jobject obj, jint DevNum, jint baud) {
	return OpenUSB(DevNum, baud);
}

JNIEXPORT jboolean JNICALL Java_com_krasutski_jni_WUSB_CloseUSB
(JNIEnv *env, jobject obj) {
	return CloseUSB();
}

JNIEXPORT jboolean JNICALL Java_com_krasutski_jni_WUSB_PurgeUSB
(JNIEnv *env, jobject obj) {
	return PurgeUSB();
}

JNIEXPORT jboolean JNICALL Java_com_krasutski_jni_WUSB_RxFrameUSB
(JNIEnv *env, jobject obj, jint To, jobject ADDR, jobject CMD, jobject N, jobject data) {
	unsigned char* buffer = NULL;
	if (data != NULL) {
		buffer = (unsigned char*)env->GetDirectBufferAddress(data);
	}

	unsigned char addr;
	unsigned char cmd;
	unsigned char n;

	bool result = RxFrameUSB(To, addr, cmd, n, buffer);

	if (result) {
		if (n > 0) {
			callObjectMethod(env, data, "limit", "(I)Ljava/nio/Buffer;", n);
		}

		setJObjectFromByte(env, ADDR, addr);
		setJObjectFromByte(env, CMD, cmd);
		setJObjectFromByte(env, N, n);
	}

	return result;
}

JNIEXPORT jboolean JNICALL Java_com_krasutski_jni_WUSB_TxFrameUSB
(JNIEnv *env, jobject obj, jbyte ADDR, jbyte CMD, jbyte N, jobject data) {

	unsigned char* buffer = NULL;
	if (data != NULL) {
		buffer = (unsigned char*)env->GetDirectBufferAddress(data);
	}

	return TxFrameUSB(ADDR, CMD, N, buffer);
}

JNIEXPORT jboolean JNICALL Java_com_krasutski_jni_WUSB_NumUSB
(JNIEnv *env, jobject obj, jobject numDevs) {
	unsigned int num;
	bool result = NumUSB(num);
	if (result) {
		setJObjectFromInt(env, numDevs, num);
	}

	return result;
}
