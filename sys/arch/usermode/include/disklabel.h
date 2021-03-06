/* $NetBSD: disklabel.h,v 1.14 2018/05/16 12:40:43 reinoud Exp $ */

/*
 * Automatically generated by ./genheaders.sh on Wed May 16 14:39:02 CEST 2018
 * Do not modify directly!
 */
#ifndef _USERMODE_DISKLABEL_H
#define _USERMODE_DISKLABEL_H

#if defined(__i386__)
#include "../../i386/include/disklabel.h"
#elif defined(__x86_64__)
#include "../../amd64/include/disklabel.h"
#elif defined(__arm__)
#include "../../arm/include/disklabel.h"
#else
#error port me
#endif
#include <machine/types.h>
#ifndef __HAVE_OLD_DISKLABEL
#undef DISKUNIT
#undef DISKPART
#undef DISKMINOR
#endif

#endif
