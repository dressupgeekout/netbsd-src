#	$NetBSD: Makefile,v 1.3 2020/09/06 07:20:27 mrg Exp $

.include <bsd.own.mk>

PROG=	fsck_v7fs
MAN=	fsck_v7fs.8
SRCS= fsck_v7fs.c main.c pathname.c inode.c datablock.c freeblock.c	\
v7fs_datablock.c v7fs_io.c v7fs_superblock.c v7fs_inode.c v7fs_file.c	\
v7fs_dirent.c v7fs_endian.c v7fs_io_user.c v7fs_inode_util.c		\
v7fs_file_util.c v7fs_superblock_util.c fsutil.c progress.c

FSCK=	${NETBSDSRCDIR}/sbin/fsck
V7FS=	${NETBSDSRCDIR}/sys/fs/v7fs
CPPFLAGS+= -I${FSCK} -I${V7FS} -DV7FS_EI
.PATH:	${FSCK} ${V7FS}

LDADD+=-lutil
DPADD+=${LIBUTIL}

CWARNFLAGS.gcc+=	${GCC_NO_ADDR_OF_PACKED_MEMBER}

.include <bsd.prog.mk>
