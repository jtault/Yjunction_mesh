# This is a simple Makefile for generating the T-junction mesh from the Bash
# script generate_blockMeshDict.  To generate the mesh, just run "make".
#
# This Makefile, however, is not that intelligent.  When you run "make", it
# knows nothing about whether blockMesh, refineMeshScript, and mirrorMesh were
# already run.  Therefore, it will essentially start all over and run all three
# again, even if they were already run and nothing else changed.

SHELL := bash -O extglob

polyMesh := constant/polyMesh

.PHONY : all block blockMeshDict clean full half mirror_x mirror_z refine

all : full

full : mirror_z
half : mirror_x

blockMeshDict : $(polyMesh)/blockMeshDict
$(polyMesh)/blockMeshDict : $(polyMesh)/generate_blockMeshDict
	$< > $@

block : blockMeshDict
	blockMesh

refine : block
	./refineMeshScript

mirror_x : refine
	cp system/mirrorMeshDict_x system/mirrorMeshDict
	mirrorMesh
	$(RM) system/mirrorMeshDict

mirror_z : mirror_x
	cp system/mirrorMeshDict_z system/mirrorMeshDict
	mirrorMesh
	$(RM) system/mirrorMeshDict

clean :
	cd $(polyMesh) && $(RM) !(generate_blockMeshDict)
