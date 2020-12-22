/*	$NetBSD$ */

//#include <errno.h>
//#include <fcntl.h>
//#include <stdarg.h>
//#include <stdio.h>
//#include <string.h>
//#include <ctype.h>
//#include <stdlib.h>
//#include <unistd.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

//#include <sys/gpio.h>
//#include <sys/ioctl.h>


int
luaopen_usbhid(lua_State *L)
{
#if 0
	static const struct luaL_Reg methods[] = {
		{ "open",	gpio_open },
		{ NULL,		NULL }
	};
	static const struct luaL_Reg gpio_methods[] = {
		{ "info",	gpio_info },
		{ "close",	gpio_close },
		{ "set",	gpio_set },
		{ "unset",	gpio_unset },
		{ "read",	gpio_read },
		{ "write",	gpio_write },
		{ "toggle",	gpio_toggle },
		{ "attach",	gpio_attach },
		{ NULL,		NULL }
	};
	int n;

	luaL_newlib(L, methods);
	luaL_setfuncs(L, gpio_methods, 0);
	gpio_set_info(L);

	/* The gpio metatable */
	if (luaL_newmetatable(L, GPIO_METATABLE)) {
		luaL_setfuncs(L, gpio_methods, 0);

		lua_pushliteral(L, "__gc");
		lua_pushcfunction(L, gpio_close);
		lua_settable(L, -3);

		lua_pushliteral(L, "__index");
		lua_pushvalue(L, -2);
		lua_settable(L, -3);

		lua_pushliteral(L, "__metatable");
		lua_pushliteral(L, "must not access this metatable");
		lua_settable(L, -3);
	}
	lua_pop(L, 1);

	for (n = 0; gpio_constant[n].name != NULL; n++) {
		lua_pushinteger(L, gpio_constant[n].value);
		lua_setfield(L, -2, gpio_constant[n].name);
	};
#endif
	return 1;
}
