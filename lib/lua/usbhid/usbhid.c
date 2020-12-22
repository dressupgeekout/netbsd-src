/* $NetBSD$ */

//#include <errno.h>
#include <fcntl.h>
//#include <stdarg.h>
//#include <stdio.h>
//#include <string.h>
//#include <ctype.h>
//#include <stdlib.h>
//#include <unistd.h>

#include <usbhid.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int luaopen_usbhid(lua_State *L);
static int luausbhid_init(lua_State *L);
static int luausbhid_get_report_desc(lua_State *L);
static int luausbhid_dispose_report_desc(lua_State *L);

/* ********** */

/*
 * usbhid.init()
 */
static int
luausbhid_init(lua_State *L)
{
	hid_init(NULL);
	lua_pushnil(L);
	return 1;
}


/*
 * descr = usbhid.get_report_desc(path)
 */
static int
luausbhid_get_report_desc(lua_State *L)
{
	const char *path = luaL_checkstring(L, 1);
	int fd = open(path, O_RDWR);
	report_desc_t descr = hid_get_report_desc(fd);
	return 1;
}


/*
 * usbhid.dispose_report_desc(descr)
 */
static int
luausbhid_dispose_report_desc(lua_State *L)
{
	// hid_dispose_report_desc(descr);
	lua_pushnil(L);
	return 1;
}

/* ********** */

int
luaopen_usbhid(lua_State *L)
{
	static const struct luaL_Reg methods[] = {
		{"init", luausbhid_init},
		{"get_report_desc", luausbhid_get_report_desc},
		{"dispose_report_desc", luausbhid_dispose_report_desc},
		{NULL, NULL},
	};

	luaL_newlib(L, methods);


	return 1;
}
