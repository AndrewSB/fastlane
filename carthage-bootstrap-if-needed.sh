#!/bin/sh

# this implements https://tech.yplanapp.com/2016/08/11/faster-carthage-bootstrap-with-cartfilediff

# it's super helpful for bootstraping dependencies on CI with carthage, it assumes your CI machine
# is caching the Carthage/ directory, and writes & reads from a copy of the Cartfile.resolved that
# is placed in Carthage/

CACHED_CARTFILE="Carthage/Cartfile.resolved"
BOOTSTRAP="carthage bootstrap --platform iOS --use-ssh"

if [ -e "$CACHED_CARTFILE" ]; then
	OUTDATED_DEPENDENCIES=$(cartfilediff "$CACHED_CARTFILE" Cartfile.resolved)
	
	if [ -z OUTDATED_DEPENDENCIES ]; then
		echo "cartfilediff says all of your cached dependencies are upto date. Exiting now"
		exit 0
	fi

	# This call to carthage potentially error out, in case
	# you specify a dependency that existed in Cartfile.resolved,
	# but not in your Cartfile. For example, if you're A, you depend
	# on B, which depends on C, and `cartfilediff` finds that C is diffed,
	# `carthage bootstrap` will fail because your Cartfile doesn't contain C
	# Created https://github.com/YPlan/CartfileDiff/issues/2
	echo "Bootstrapping outdated dependencies: $OUTDATED_DEPENDENCIES"
	$BOOTSTRAP  "$OUTDATED_DEPENDENCIES"

	# if it fails, let's just do a clean carthage bootstrap for everything
	if ! [ $? -eq 0 ]; then
		echo "Bootstrapping outdated dependencies: $OUTDATED_DEPENDENCIES errd out. Doing a clean bootstrap"
		$BOOTSTRAP|| exit 1
	else
		echo "Bootstrapping $OUTDATED_DEPENDENCIES succeeded"
	fi

else
	echo "Cached Cartfile.resolved not found, bootstrapping all dependencies"
	$BOOTSTRAP || exit 1
fi

# Assuming everything succeeded, copy the newly minted Cartfile.resolved
# to the cached directory so we can use it next we `cartfilediff`
echo "Caching Cartfile.resolved"
cp Cartfile.resolved Carthage
