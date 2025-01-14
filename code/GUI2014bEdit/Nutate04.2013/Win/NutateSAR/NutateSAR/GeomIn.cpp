/*=========================================================================

  Program:   NutateSAR
  Module:    $RCSfile: GeomIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include "GeomIn.h"
#include<cassert>
#include<fstream>
#include<iostream>

/* ********************

1) A geometry file is written as:

Total # Voxels
xMin, xMax
yMin, yMax
zMin, zMax
ctrX, ctrY, ctrZ
widX, widY, widZ
----------
x y z id
...

2) CmdFlags is written as:

xMin
xMax
yMin
yMax
zMin
zMax
ctrX
ctrY
ctrZ
widX
widY
widZ

It is processed first from CmdInterp, and if it is false, 
it reads in default value from file.

3) GeomHeader is written as:

xMin
xMax
yMin
yMax
zMin
zMax
ctrX
ctrY
ctrZ
widX
widY
widZ

******************** */

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().geom" accesses a public data value instead of 
// using a method to return the value.
GeomIn::GeomIn(CmdInterp & cmdInterp)
{
	fName = cmdInterp.getCmdValues().geom;
	geomFlag = readGeomHeader(cmdInterp) && readGeomData();
}

GeomIn::~GeomIn()
{
	geomHeader.geomList.clear();
	geomData.clear();
}

// ------------------------------------------------------------------------------

bool GeomIn::readGeomHeader(CmdInterp cmdInterp)
{
	std::fstream fHandle;
	float buff;
	
	fHandle.open(fName.c_str(), std::ios::in | std::ios::binary);

	if (fHandle.fail())
	{
		std::cout << "\n\"" << fName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}
	
	// Below, the procedure is to check for command line input of the value first. If command line input
	// was present, that value will be used to define the volume of interest (voxels to be input). We
	// assume that the command line values will be less than the file max/ greater than the file min. If
	// no information was specified in the command line, it is assumed that there will be no constraint.
	// In this case, we use the min and/or max value found in the header which indicates the highest or
	// lowest value found anywhere in the file.
	// GeomHeader_________________________________________________________
	
	// totNumVox_______________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	geomHeader.totNumVox = (unsigned int) buff;

	// xMin_______________________________________________________
	if (cmdInterp.getCmdFlags().min.x == false)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		geomHeader.min.x = (float) buff;
	}
	else
	{
		fHandle.seekg (4*1, std::ios::cur);
		geomHeader.min.x = cmdInterp.getCmdValues().min.x;
	}

	// xMax_______________________________________________________
	if (cmdInterp.getCmdFlags().max.x == false)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		geomHeader.max.x = (float) buff;
	}
	else
	{
		fHandle.seekg (4*1, std::ios::cur);
		geomHeader.max.x =  cmdInterp.getCmdValues().max.x;
	}

	// yMin_______________________________________________________
	if (cmdInterp.getCmdFlags().min.y == false)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		geomHeader.min.y = (float) buff;
	}
	else
	{
		fHandle.seekg (4*1, std::ios::cur);
		geomHeader.min.y =  cmdInterp.getCmdValues().min.y;
	}

	// yMax_______________________________________________________
	if (cmdInterp.getCmdFlags().max.y == false)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		geomHeader.max.y = (float) buff;
	}
	else
	{
		fHandle.seekg (4*1, std::ios::cur);
		geomHeader.max.y =  cmdInterp.getCmdValues().max.y;
	}

	// zMin_______________________________________________________
	if (cmdInterp.getCmdFlags().min.z == false)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		geomHeader.min.z = (float) buff;
	}
	else
	{
		fHandle.seekg (4*1, std::ios::cur);
		geomHeader.min.z =  cmdInterp.getCmdValues().min.z;
	}

	// zMax_______________________________________________________
	if (cmdInterp.getCmdFlags().max.z == false)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		geomHeader.max.z = (float) buff;
	}
	else
	{
		fHandle.seekg (4*1, std::ios::cur);
		geomHeader.max.z =  cmdInterp.getCmdValues().max.z;
	}
	
	// Check Point________________________________________________
	if (!(geomHeader.min <= geomHeader.max))
	{
		std::cout << "Error: Region of interest definition shows ROI_min > ROI_max.\nCheck command line and/or geometry file header.\n";
		std::cout << "Press enter to continue.\n";
		std::cin.get();
		return false;
	}
	
	fHandle.close();
	return true;
}

// ------------------------------------------------------------------------------

bool GeomIn::readGeomData()
{
	printf("Reading Geometry data...");

	std::fstream fHandle;
	float buff;

	fHandle.open(fName.c_str(), std::ios::in | std::ios::binary);
	
	if (fHandle.fail())
	{
		std::cout << "\n\"" << fName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	// Skip GeomHeader
	fHandle.seekg (4*13, std::ios::cur);

	// Geometry Data______________________________________________
	Voxel tempVoxel;

	unsigned int j = 0;
	unsigned int k = 0;

	while(j < geomHeader.totNumVox)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempVoxel.geomInfo.pos.x = (float) buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempVoxel.geomInfo.pos.y = (float) buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempVoxel.geomInfo.pos.z = (float) buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempVoxel.geomInfo.id = (int) buff;

		if (geomHeader.min <= tempVoxel.geomInfo.pos && tempVoxel.geomInfo.pos <= geomHeader.max)
		{
			geomData.push_back(tempVoxel);
			k++;
			geomHeader.geomList.push_back(j);
		}
		j++;
	}

	printf("Finished!\n");

	std::cout << "Number of voxels in VOI [" << geomHeader.min.x << "," << geomHeader.max.x << "], [" << geomHeader.min.y 
		<< "," << geomHeader.max.y << "], [" << geomHeader.min.z << "," << geomHeader.max.z << "]: " << k <<std::endl;
	std::cout << "Number of all input voxels: " << geomHeader.totNumVox <<std::endl;

	fHandle.close();
	return true;
}

// ------------------------------------------------------------------------------
