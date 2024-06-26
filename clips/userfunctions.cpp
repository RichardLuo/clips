   /*******************************************************/
   /*      "C" Language Integrated Production System      */
   /*                                                     */
   /*               CLIPS Version 6.30  08/16/14          */
   /*                                                     */
   /*                USER FUNCTIONS MODULE                */
   /*******************************************************/

/*************************************************************/
/* Purpose:                                                  */
/*                                                           */
/* Principal Programmer(s):                                  */
/*      Gary D. Riley                                        */
/*                                                           */
/* Contributing Programmer(s):                               */
/*                                                           */
/* Revision History:                                         */
/*                                                           */
/*      6.24: Created file to seperate UserFunctions and     */
/*            EnvUserFunctions from main.c.                  */
/*                                                           */
/*      6.30: Removed conditional code for unsupported       */
/*            compilers/operating systems (IBM_MCW,          */
/*            MAC_MCW, and IBM_TBC).                         */
/*                                                           */
/*************************************************************/

/***************************************************************************/
/*                                                                         */
/* Permission is hereby granted, free of charge, to any person obtaining   */
/* a copy of this software and associated documentation files (the         */
/* "Software"), to deal in the Software without restriction, including     */
/* without limitation the rights to use, copy, modify, merge, publish,     */
/* distribute, and/or sell copies of the Software, and to permit persons   */
/* to whom the Software is furnished to do so.                             */
/*                                                                         */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS */
/* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF              */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT   */
/* OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY  */
/* CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES */
/* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN   */
/* ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF */
/* OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.          */
/*                                                                         */
/***************************************************************************/

#include "clips.h"
#include <math.h>
#include <string>
#include <vector>
#include <utils/Log.h>

#include "consts/consts.h"
#include "service/ActionDesc.h"
#include "service/BindingManager.h"
using namespace android;

void UserFunctions(void);
void EnvUserFunctions(void *);

/*********************************************************/
/* UserFunctions: Informs the expert system environment  */
/*   of any user defined functions. In the default case, */
/*   there are no user defined functions. To define      */
/*   functions, either this function must be replaced by */
/*   a function with the same name within this file, or  */
/*   this function can be deleted from this file and     */
/*   included in another file.                           */
/*********************************************************/
void UserFunctions()
  {
   // Use of UserFunctions is deprecated.
   // Use EnvUserFunctions instead.
  }
  
/***********************************************************/
/* EnvUserFunctions: Informs the expert system environment */
/*   of any user defined functions. In the default case,   */
/*   there are no user defined functions. To define        */
/*   functions, either this function must be replaced by   */
/*   a function with the same name within this file, or    */
/*   this function can be deleted from this file and       */
/*   included in another file.                             */
/***********************************************************/
class Foo {

  public:

    // EnvDefineFunction2(environment,"rta",'d',PTIEF rta,"rta","22n");
    static double rta(void *environment) {
        double base, height;
        /* Check for exactly two arguments */
        if (EnvArgCountCheck(environment,"rta",EXACTLY,2) == -1)
            return(-1.0);
        /* Get the values for the 1st and 2nd arguments. */
        base = EnvRtnDouble(environment,1);
        height = EnvRtnDouble(environment,2);
        /* Return the area of the triangle. */ /*==================================*/
        // return(0.5 * base * height);
        return  100.0;
    }

    // Use EnvDefineFunction2(environment,"mul",'g',PTIEF mul,"mul","22n");
    static long long mul(void *environment) {
        DATA_OBJECT temp;
        long long firstNumber, secondNumber;
        // Check for exactly two arguments
        if (EnvArgCountCheck(environment,"mul",EXACTLY,2) == -1) {
            return(1LL);
        }
        // Get the first argument using the EnvArgTypeCheck function. */
        // Return if the correct type has not been passed. 
        if (EnvArgTypeCheck(environment,"mul",1,INTEGER_OR_FLOAT,&temp) == 0) {
            return(1LL);
        }
        // Convert the first argument to a long long integer. If it's
        // not an integer, then it must be a float (so round it to
        // the nearest integer using the C library ceil
        // function
        if (GetType(temp) == INTEGER) {
            firstNumber = DOToLong(temp);
        } else {                        // the type must be FLOAT
            firstNumber = (long long) ceil(DOToDouble(temp) - 0.5);
        }
        // Get the second argument using the EnvRtnUnknown
        // function. Note that no type error checking is
        // performed.
        EnvRtnUnknown(environment,2,&temp);
        // Convert the second argument to a long integer. If it's not
        // an integer or a float, then it's the wrong
        // type.
        if (GetType(temp) == INTEGER) {
            secondNumber = DOToLong(temp);
        } else if (GetType(temp) == FLOAT) {
            secondNumber = (long long) ceil(DOToDouble(temp) - 0.5);
        } else {
            return(1LL);
        }

        // Multiply the two values together and return the result.
        return (firstNumber * secondNumber);
    }

    static long long MFLength(void *environment) {
        DATA_OBJECT argument;

        /*=================================*/
        /* Check for exactly one argument. */
        /*=================================*/
        if (EnvArgCountCheck(environment,"mfl",EXACTLY,1) == -1)
            return(-1LL);

        /*====================================================*/
        /* Check that the 1st argument is a multifield value. */
        /*====================================================*/

        if (EnvArgTypeCheck(environment,"mfl",1,MULTIFIELD,&argument) == 0)
        { return(-1LL); }

        /*============================================*/
        /* Return the length of the multifield value. */
        /*============================================*/
        return ((long long) GetDOLength(argument));
    }

    static long long CntMFChars(void *environment) {
        DATA_OBJECT argument;
        void *multifieldPtr;

        long end, i;
        long long count = 0;
        const char *tempPtr;

        /*=================================*/
        /* Check for exactly one argument. */
        /*=================================*/
        if (EnvArgCountCheck(environment, "cmfc", EXACTLY, 1) == -1)
            return (0LL);

        /*======================================================*/
        /* Check that the first argument is a multifield value. */
        /*======================================================*/
        if (EnvArgTypeCheck(environment, "cmfc", 1, MULTIFIELD, &argument) == 0) {
            return (0LL);
        }

        /*=====================================*/
        /* Count the characters in each field. */
        /*=====================================*/
        end = GetDOEnd(argument);
        multifieldPtr = GetValue(argument);
        for (i = GetDOBegin(argument); i <= end; i++) {
            if ((GetMFType(multifieldPtr, i) == STRING) ||
                (GetMFType(multifieldPtr, i) == SYMBOL)) {
                tempPtr = ValueToString(GetMFValue(multifieldPtr, i));
                count += strlen(tempPtr);
            }
        }

        /*=============================*/
        /* Return the character count. */
        /*=============================*/
        return(count);
    }

    // static long access_people(void *environment) {
    //     if (EnvArgCountCheck(environment, "access-people", EXACTLY, 1) == -1) {
    //         return -1;
    //     }
    //     DATA_OBJECT argument;
    //     if (EnvArgTypeCheck(environment, "access-people", 1, INSTANCE_ADDRESS, &argument) == FALSE) {
    //         return -1;
    //     }
    //     void *actions = DOToPointer(argument);
    //     EnvDirectGetSlot(environment, actions, "address", &argument);
    //     const char *str = DataObjectToString(environment, &argument);
    //     // void *address = DOToLong(temp);
    //     // EnvDirectGetSlot(environment, );
    //     return 0;
    // }


    static long long ins_addr_test(void *environment) {
        void *multifieldPtr;

        long end, i;
        long long count = 0;
        const char *tempPtr;

        /*=================================*/
        /* Check for exactly one argument. */
        /*=================================*/
        if (EnvArgCountCheck(environment, "ins-addr", EXACTLY, 1) == -1) {
            LOGW("ERR: on EnvArgCountCheck");
            return -1;
        }

        /*======================================================*/
        /* Check that the first argument is a multifield value. */
        /*======================================================*/
        DATA_OBJECT arg;
        if (EnvArgTypeCheck(environment, "ins-addr", 1, INSTANCE_ADDRESS, &arg) == FALSE) {
            LOGW("ERR: on EnvArgTypeCheck");
            return -1;
        }

        void *actions = DOToPointer(arg);
        EnvDirectGetSlot(environment, actions, "address", &arg);
        const char *str = DataObjectToString(environment, &arg);
        LOGW("got the str: %s", str);

        return 0;
    }


    static intBool fire_actions(void *environment) {
        const char *command = "fire-actions";
        if (EnvArgCountCheck(environment, command, EXACTLY, 1) == -1) {
            return FALSE;
        }

        DATA_OBJECT arg;
        if (EnvArgTypeCheck(environment, command, 1, MULTIFIELD, &arg) == 0) {
            return FALSE;
        }

        const long end = GetDOEnd(arg);
        void *multi_field_ptr = GetValue(arg);
        std::vector<ActionDesc> action_list;
        for (long i = GetDOBegin(arg); i <= end; i++) {
            if ((GetMFType(multi_field_ptr, i) != INSTANCE_NAME)) {
                LOGW("ERR: %ld is not a INSTANCE_NAME", i);                
                continue;
            }

            const char *name = ValueToString(GetMFValue(multi_field_ptr, i));
            void *action = EnvFindInstance(environment, NULL, name, TRUE);
            if (action == NULL) {
                LOGW("ERR: no action, on EnvFindInstance");
                continue;
            }

            EnvDirectGetSlot(environment, action, "address", &arg);
            const std::string address = DataObjectToString(environment, &arg);
            EnvDirectGetSlot(environment, action, "method", &arg);
            const std::string method = DataObjectToString(environment, &arg);
            if (method == "set-on-off") {
                EnvDirectGetSlot(environment, action, "on-off-cmd", &arg);
                const std::string command = DataObjectToString(environment, &arg);
                LOGW("OK: method %s, address %s, on-off-cmd %s", method.c_str(), address.c_str(), command.c_str());
                action_list.push_back(ActionDesc(address, VD_ON_OFF_STATUS, atoi(command.c_str())));
            } else if (method == "set-alert-level") {
                EnvDirectGetSlot(environment, action, "alert-level", &arg);
                const std::string alert_level = DataObjectToString(environment, &arg);
                LOGW("OK: method %s, address %s, alert_level %s", method.c_str(), address.c_str(), alert_level.c_str());
                action_list.push_back(ActionDesc(address, VD_ALERT_LEVEL, atoi(alert_level.c_str())));
            } else {
                LOGE("ERR: unknown-method %s, address %s", method.c_str(), address.c_str());
            }
            BM::getInstance().fireActions(action_list);
        }

        return TRUE;
    }

    static intBool fire_binding(void *environment) {
        const char *command = "fire-binding";
        if (EnvArgCountCheck(environment, command, EXACTLY, 1) == -1) {
            return FALSE;
        }

        DATA_OBJECT arg;
        if (EnvArgTypeCheck(environment, command, 1, SYMBOL, &arg) == 0) {
            return FALSE;
        }
        const std::string address = DOToString(arg);
        // BM::getInstance().fireActions(action_list);
        BM::getInstance().fireBinding(address);
        return TRUE;
    }



};

void EnvUserFunctions(void *environment) {
    EnvDefineFunction2(environment, "mul", 'g', PTIEF Foo::mul, "mul", "22n");
    EnvDefineFunction2(environment, "rta", 'd', PTIEF Foo::rta, "rta", "22n");
    EnvDefineFunction2(environment, "mfl", 'g', PTIEF Foo::MFLength, "MFLength", "11m");
    EnvDefineFunction2(environment, "cmfc", 'g', PTIEF Foo::CntMFChars, "CntMFChars", "11m");
    EnvDefineFunction2(environment, "ins-addr", 'g', PTIEF Foo::ins_addr_test, "ins_addr_test", "11x");
    EnvDefineFunction2(environment, "fire-actions", 'b', PTIEF Foo::fire_actions, "fire_actions", "11m");
    EnvDefineFunction2(environment, "fire-binding", 'b', PTIEF Foo::fire_binding, "fire_binding", "11k");
}

