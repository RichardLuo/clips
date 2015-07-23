/*
 * Copyright (C) 2014 The X-Live Project
 *
 * @author Richard Luo, cdominant7@gmail.com
 * 
 * @date   2015-07-02 16:57:08
 * 
 ****************************************************************** 
 */

#define LOG_TAG "clips_test1"

#include "clips/clips.h"

//#define LOG_NDEBUG 0
#include <utils/Log.h>
#include <utils/Errors.h>
#include <string>

using namespace android;

static int test_devices() {
    void *theEnv = CreateEnvironment();
    /*=======================================================*/
    /* Load the classes, message-handlers, generic functions */
    /* and generic functions necessary for handling complex */
    /* numbers. */
    /*=======================================================*/
    LOG_IF_RETURN(!EnvLoad(theEnv, "/zb/clips/devices.clp"), "ERR: on EnvLoad");

    /*=========================================================*/
    /* Create two complex numbers. Message-passing is used to */
    /* create the first instance c1, but c2 is created and has */
    /* its slots set directly. */
    /*=========================================================*/
    // void *c1 = EnvMakeInstance(theEnv, "(c1 of COMPLEX (real 1) (imag 10))");
    void *pir1 = EnvMakeInstance(theEnv, "(pir1 of PirPanel (pir-left safe) (pir-right alarm))");
    void *pir2 = EnvCreateRawInstance(theEnv, EnvFindDefclass(theEnv, "PirPanel"), "pir2");

    DATA_OBJECT result;
    result.type = INTEGER;
    result.value = EnvAddLong(theEnv, (long)(pir1));
    // result.value = EnvAddExternalAddress(theEnv, theEnv, C_POINTER_EXTERNAL_ADDRESS);
    EnvDirectPutSlot(theEnv, pir1, "address", &result);

    LOGFL("================ pir1:%ld pir2:%ld ================", (long)pir1, (long)pir2);
    
    DATA_OBJECT insdata;
    SetType(insdata, INSTANCE_ADDRESS);
    SetValue(insdata, pir1);
    EnvSend(theEnv, &insdata, "print", NULL, &result);
    
    SetType(insdata, INSTANCE_ADDRESS);
    SetValue(insdata, pir2);
    EnvSend(theEnv, &insdata, "print", NULL, &result);
    // LOGFL("================ test_devices ================");

    return 0;
}


static void test_manipulate_object() {
    void *theEnv = CreateEnvironment();
    /*=======================================================*/
    /* Load the classes, message-handlers, generic functions */
    /* and generic functions necessary for handling complex */
    /* numbers. */
    /*=======================================================*/
    EnvLoad(theEnv, "/zb/clips/complex.clp");

    /*=========================================================*/
    /* Create two complex numbers. Message-passing is used to */
    /* create the first instance c1, but c2 is created and has */
    /* its slots set directly. */
    /*=========================================================*/
    void *c1 = EnvMakeInstance(theEnv, "(c1 of COMPLEX (real 1) (imag 10))");
    void *c2 = EnvCreateRawInstance(theEnv, EnvFindDefclass(theEnv, "COMPLEX"), "c2");

    DATA_OBJECT result;
    result.type = INTEGER;
    result.value = EnvAddLong(theEnv, 3LL);
    EnvDirectPutSlot(theEnv, c2, "real", &result);

    result.type = INTEGER;
    result.value = EnvAddLong(theEnv, -7LL);
    EnvDirectPutSlot(theEnv, c2, "imag", &result);

    /*===========================================================*/
    /* Call the function '+' which has been overloaded to handle */
    /* complex numbers. The result of the complex addition is */
    /* stored in a new instance of the COMPLEX class. */
    /*===========================================================*/
    EnvFunctionCall(theEnv, "+", "[c1] [c2]", &result);
    void *c3 = EnvFindInstance(theEnv, NULL, DOToString(result), TRUE);

    /*=======================================================*/
    /* Print out a summary of the complex addition using the */
    /* "print" and "magnitude" messages to get information */
    /* about the three complex numbers. */
    /*=======================================================*/
    EnvPrintRouter(theEnv, STDOUT, "The addition of\n\n");

    DATA_OBJECT insdata;
    SetType(insdata, INSTANCE_ADDRESS);
    SetValue(insdata, c1);
    EnvSend(theEnv, &insdata, "print", NULL, &result);

    EnvPrintRouter(theEnv, STDOUT, "\nand\n\n");
    SetType(insdata, INSTANCE_ADDRESS);
    SetValue(insdata, c2);
    EnvSend(theEnv, &insdata, "print", NULL, &result);

    EnvPrintRouter(theEnv, STDOUT, "\nis\n\n");
    SetType(insdata, INSTANCE_ADDRESS);
    SetValue(insdata, c3);
    EnvSend(theEnv, &insdata, "print", NULL, &result);
    EnvPrintRouter(theEnv, STDOUT, "\nand the resulting magnitude is\n\n");
    SetType(insdata, INSTANCE_ADDRESS);
    SetValue(insdata, c3);
    EnvSend(theEnv, &insdata, "magnitude", NULL, &result);

    char numbuf[20];
    sprintf(numbuf, "%lf\n", DOToDouble(result));
    EnvPrintRouter(theEnv, STDOUT, numbuf);
}

static int test_bindings() {
    void *theEnv = CreateEnvironment();
    const char *load_files[] = {
        "/zb/clips/main.clp",
        "/zb/clips/device.clp",
        "/zb/clips/action.clp",
        "/zb/clips/binding.clp",
    };
    for (size_t i = 0;
         i < ARRAY_SIZE(load_files); ++i) {
        const char *file = load_files[i];
        const int res = EnvLoad(theEnv, file);
        LOG_IF_RETURN(res != 1, "ERR: on EnvLoad %s, err:%d", file, res);
    }

    void *plug1 = EnvMakeInstance(theEnv,
                                  "(plug1 of DEVICE::SmartPlug "
                                  "(address SSS) "
                                  "(on-off-status off))");
   
    LOG_IF_RETURN(plug1 == NULL, "ERR: on create plug1 instance");

    const char *pir = "(pir1 of DEVICE::PirPanel "
                      "(address PPP) "
                      "(status available) "
                      "(pir-status safe))";
    void *pir1 = EnvMakeInstance(theEnv, pir);
    LOG_IF_RETURN(pir == NULL, "ERR: on create pir instance");

    DATA_OBJECT inst, res;
    SetType(inst, INSTANCE_ADDRESS);
    SetValue(inst, plug1);
    EnvSend(theEnv, &inst, "print", NULL, &res);

    SetType(inst, INSTANCE_ADDRESS);
    SetValue(inst, pir1);
    EnvSend(theEnv, &inst, "print", NULL, &res);

    return 0;
}


static void test_EnvGetNextInstanceInClassAndSubclasses() {
    void *theEnv;
    DATA_OBJECT iterate;
    void *theInstance;
    void *theClass;
    
    theEnv = CreateEnvironment();
    
    EnvBuild(theEnv,"(defclass A (is-a USER))");
    EnvBuild(theEnv,"(defclass B (is-a USER))");
    EnvMakeInstance(theEnv,"(a1 of A)");
    EnvMakeInstance(theEnv,"(a2 of A)");
    EnvMakeInstance(theEnv,"(b1 of B)");
    EnvMakeInstance(theEnv,"(b2 of B)");
    
    theClass = EnvFindDefclass(theEnv,"USER");

    for (theInstance = EnvGetNextInstanceInClassAndSubclasses(theEnv,&theClass, NULL,&iterate);
         theInstance != NULL;
         theInstance = EnvGetNextInstanceInClassAndSubclasses(theEnv,&theClass,
                                                              theInstance,&iterate)) {
        EnvPrintRouter(theEnv, WDISPLAY, EnvGetInstanceName(theEnv,theInstance));
        EnvPrintRouter(theEnv, WDISPLAY, "\n");
    }
}

int test_EnvSend (int argc, char *argv[]) {
    void *theEnv;
    void *myInstancePtr;
    DATA_OBJECT insdata, rtn;

    theEnv = CreateEnvironment();
    EnvBuild(theEnv,"(defclass MY-CLASS (is-a USER))");

    // Note the use of escape characters to embed quotation marks.
    // (defmessage-handler MY-CLASS my-msg (?x ?y ?z)
    // (printoutt?x""?y""?zcrlf))
    const char *cs = "(defmessage-handler MY-CLASS my-msg (?x ?y ?z)"
                     " (printout t ?x \" \" ?y \" \" ?z crlf))";
    
    EnvBuild(theEnv, cs);
    char buf[128];
    std::string str;
    for (const char *s = 0; (s = gets(buf)) != NULL; ) {
        myInstancePtr = EnvMakeInstance(theEnv, "(my-instance of MY-CLASS)");
        SetType(insdata, INSTANCE_ADDRESS);
        SetValue(insdata, myInstancePtr);
        str = buf;
        LOGFL("s: [%s]", str.c_str());
        // EnvSend(theEnv, &insdata, "my-msg", "1 abc 3", &rtn);
        EnvSend(theEnv, &insdata, "my-msg", str.c_str(), &rtn);
    }

    return 0;
}

int main (int argc, char *argv[]) {
    test_bindings();
    // test_devices();
    // test_manipulate_object();
    // test_EnvGetNextInstanceInClassAndSubclasses();
    return 0;
}
