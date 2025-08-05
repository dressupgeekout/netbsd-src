# $NetBSD$
#
# Copyright (c) 2025 The NetBSD Foundation, Inc.
# All rights reserved.
#
# This code is derived from software contributed to The NetBSD Foundation
# by Charlotte Koch.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

atf_test_case a_flag
a_flag_head()
{
	atf_set "descr" "Verify the command specified by '-a' actually executes"
	atf_set "use.fs" true
}

a_flag_body()
{
	touch input

	atf_check -s exit:0 -o match:OK \
		install -a 'echo OK' input output
}


atf_test_case backup
backup_head()
{
	atf_set "descr" "Verify file backup with '-b,-B'"
	atf_set "use.fs" true
}

backup_body()
{
	touch input
	touch output

	# Verify backup works with default suffix 
	atf_check -s exit:0 \
		install -b input output

	atf_check -s exit:0 \
		test -f output.old

	# Verify backup with custom suffix
	rm -f output.old

	atf_check -s exit:0 \
		install -b -B ".original" input output

	atf_check -s exit:0 \
		test -f output.original

	# Verify backup with the special automatic numbering
	rm -f output.original

	ntries=4

	while [ ${ntries} -gt 0 ]; do
		atf_check -s exit:0 \
			install -b -B ".%02d" input output
		ntries=$((ntries-1))
	done

	for suffix in $(seq -f "%02g" 0 3); do
		atf_check -s exit:0 \
			test -f output.${suffix}
	done
}


atf_test_case c_flag
c_flag_head()
{
	atf_set "descr" "Verify '-c' still works"
	atf_set "use.fs" true
}

c_flag_body()
{
	touch input

	atf_check -s exit:0 \
		install -c input output

	atf_check -s exit:0 \
		test -f output
}


atf_test_case mkdirs
mkdirs_head()
{
	atf_set "descr" "Verify '-d' creates all directories"
	atf_set "use.fs" true
}

mkdirs_body()
{
	destination=output/with/several/subdirs

	atf_check -s exit:0 \
		install -d ${destination}

	atf_check -s exit:0 \
		test -d ${destination}
}


atf_test_case set_output_perms
set_output_perms_head()
{
	atf_set "descr" "Verify '-m' sets permissions on output file"
	atf_set "use.fs" true
}

set_output_perms_body()
{
	touch input
	chmod u=rwx,go=rx input

	atf_check -s exit:0 -o match:100755 \
		stat -f "%p" input

	atf_check -s exit:0 \
		install -m u=rw,go=r input output

	atf_check -s exit:0 -o match:100644 \
		stat -f "%p" output
}


atf_test_case set_output_flags
set_output_flags_head()
{
	atf_set "descr" "Verify '-f' sets flags on output file"
	atf_set "use.fs" true
}

set_output_flags_body()
{
	touch input
	chflags nouchg input

	atf_check -s exit:0 -o match:0 \
		stat -f "%f" input

	atf_check -s exit:0 \
		install -f uchg input output

	atf_check -s exit:0 -o match:2 \
		stat -f "%f" output

	# Turn off the flag again on purpose so that ATF can actually clean up
	# the test files.
	chflags nouchg output
}


atf_test_case links
links_head()
{
	atf_set "descr" "Confirm file system links with '-l'"
	atf_set "use.fs" true
}

links_body()
{
	touch input

	atf_check -s exit:0 \
		install -l rs input output

	atf_check -s exit:0 -o inline:input \
		readlink -n output
}


atf_test_case preserve_times
preserve_times_head()
{
	atf_set "descr" "Ensure '-p' preserves mtime"
	atf_set "use.fs" true
}

preserve_times_body()
{
	touch -t 197001010000 input

	atf_check -s exit:0 \
		install input output1 

	atf_check -s exit:0 \
		install -p input output2

	mtime_input=$(stat -f %m input)
	mtime_out1=$(stat -f %m output1)
	mtime_out2=$(stat -f %m output2)

	atf_check_equal ${mtime_input} ${mtime_out2}

	test ${mtime_1} -ne ${mtime_2} \
		|| atf_fail "mtime was expected to change"
}


atf_test_case devnull
devnull_head()
{
	atf_set "descr" "Installing /dev/null should create an empty file"
	atf_set "use.fs" true
}

devnull_body()
{
	atf_check -s exit:0 \
		install /dev/null output

	atf_check -s exit:0 -o empty \
		cat output
}


atf_test_case metalog
metalog_head()
{
	atf_set "descr" "Verify generating the metalog is OK"
	atf_set "use.fs" true
}

metalog_body()
{
	touch input
	D=destdir

	# First, check basic metalog sanity.
	atf_check -s exit:0 \
		install -d ${D}

	atf_check -s exit:0 \
		install -M ${D}/METALOG input ${D}/output

	metalog_field1="$(head -1 ${D}/METALOG | awk '{print $1}')"
	atf_check_equal "${metalog_field1}" "./${D}/output"

	# Then check metalog-with-hashes.
	rm -rf ${D}

	atf_check -s exit:0 \
		install -d ${D}

	atf_check -s exit:0 \
		install -M ${D}/METALOG -h sha256 input ${D}/output

	metalog_field2="$(head -1 ${D}/METALOG | awk '{print $5}')"
	the_sha="$(sha256 -q input)"
	atf_check_equal "${metalog_field2}" "sha256=${the_sha}"
}


atf_test_case stripping
stripping_head()
{
	atf_set "descr" "Confirm that stripping binaries works"
	atf_set "use.fs" true
	atf_set "require.progs" "cc"
}

stripping_body()
{
	cat > example.c <<EOF
#include <stdio.h>
#include <stdlib.h>
int
main(void)
{
	printf("EXAMPLE PROGRAM\\n");
	return EXIT_SUCCESS;
}
EOF
	atf_check -s exit:0 \
		cc -o input example.c

	atf_check -s exit:0 \
		install -s input output

	sha_before="$(sha256 -q input)"
	sha_after="$(sha256 -q output)"

	test "${sha_before}" != "${sha_after}" \
		|| atf_fail "Stripped binary was expected to be different from original"
}


atf_init_test_cases()
{
	atf_add_test_case a_flag
	atf_add_test_case backup
	atf_add_test_case c_flag
	atf_add_test_case mkdirs
	atf_add_test_case set_output_perms
	atf_add_test_case set_output_flags
	atf_add_test_case links
	atf_add_test_case preserve_times
	atf_add_test_case devnull
	atf_add_test_case metalog
	atf_add_test_case stripping
}
