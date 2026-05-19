// Local override for Clang + DragonFly 5.0 + GCC 8.3 libstdc++.
//
// GCC 8.3's DragonFly libstdc++ target config enables C99 "check"
// redeclarations for functions like wcstold, atoll, snprintf, etc.
// Clang 21 rejects those redeclarations against DragonFly 5.0 libc
// headers due to exception-specification mismatches. Disabling the
// check variants preserves the normal C99 availability macros while
// avoiding the incompatible redeclarations.

#ifndef _GLIBCXX_OS_DEFINES
#define _GLIBCXX_OS_DEFINES 1

#define _GLIBCXX_USE_C99 1
#define _GLIBCXX_USE_C99_STDIO 1
#define _GLIBCXX_USE_C99_STDLIB 1
#define _GLIBCXX_USE_C99_WCHAR 1
#define _GLIBCXX_USE_C99_CHECK 0
#define _GLIBCXX_USE_C99_DYNAMIC (!(__ISO_C_VISIBLE >= 1999))
#define _GLIBCXX_USE_C99_LONG_LONG_CHECK 0
#define _GLIBCXX_USE_C99_LONG_LONG_DYNAMIC (_GLIBCXX_USE_C99_DYNAMIC || !defined __LONG_LONG_SUPPORTED)

#endif
