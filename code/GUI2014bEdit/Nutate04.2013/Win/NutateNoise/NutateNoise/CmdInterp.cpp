/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: CmdInterp.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 18:54:15 $
  Version:   $Revision: 1.2 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"CmdInterp.h"
#include <exception>

// ------------------------------------------------------------------------------

static void initCmdMap()	// :TODO: make this a member function?
{
	cmdMap["xMin"] = cmd_xMin;
	cmdMap["xMax"] = cmd_xMax;
	cmdMap["yMin"] = cmd_yMin;
	cmdMap["yMax"] = cmd_yMax;
	cmdMap["zMin"] = cmd_zMin;
	cmdMap["zMax"] = cmd_zMax;
	cmdMap["xWid"] = cmd_xWid;
	cmdMap["yWid"] = cmd_yWid;
	cmdMap["zWid"] = cmd_zWid;
	cmdMap["TissueTypeFile"] = cmd_tiss;
	cmdMap["GeometryFile"] = cmd_geom;
	cmdMap["E1MinsFile"] = cmd_e1Mins;
	cmdMap["KNoiseFile"] = cmd_kNoise;
	cmdMap["SequenceFile"] = cmd_seqn;
	cmdMap["NEX"] = cmd_NEX;
}

// ------------------------------------------------------------------------------

CmdInterp::CmdInterp()
{
	// Default constructor: Set all default values.
	cmdValues.e1Mins.clear();
	cmdValues.kNoise = "kNoise.bin";

	cmdValues.tiss.clear();
	cmdValues.geom.clear();
	cmdValues.seqn.clear();

	cmdValues.min = 0;	cmdValues.max = 0;
	cmdValues.wid= 0;

	cmdValues.NEX = 1;

	// Set all default flags (false = no cmd input).

	cmdFlags.kNoise = false;
	cmdFlags.e1Mins = false;
	cmdFlags.tiss = false;
	cmdFlags.geom = false;
	cmdFlags.seqn = false;
	cmdFlags.min = false;	cmdFlags.max = false;
	cmdFlags.wid = false;

	cmdFlags.NEX = false;
}

// ------------------------------------------------------------------------------

bool CmdInterp::interpCmd(int argc, char *argv[])
{

	std::string option;
	std::string parameter;
	size_t ptr;

	initCmdMap();

	for (int count = 1; count < argc; count++)
	{
		option = argv[count];								// fill the "option" string with the entire line, for example option will contain "b0=3.0"
		ptr = option.find("=");								// find the '=' sign in the option string
		parameter = option.substr(ptr + 1);					// place everything after the '=' sign in the "parameter" string. now, option = "b0=3.0" and parameter = "3.0"
		option.erase(option.begin() + ptr, option.end());	// remove everything after and including the '=' sign. now, option = "b0" and parameter = "3.0"

		static std::map<std::string, StringValue>::iterator it; // :TODO: why static?
		try
		{
			it = cmdMap.find(option);
			if (it == cmdMap.end())
			{
				// if the command line input does not match a value in the map, throw error with the text from erroneous command line input
				throw option;
			}
			else
			{
				switch (it->second) // :TODO: (comment not by jmm) :BUG: If the match is incomplete, error occurs here, need to fix, April 28, 2009. TO TEST
				{
					// find the matching value and assign command line parameters where appropriate
					case cmd_xMin:
						cmdValues.min.x = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.min.x = true;
						break;

					case cmd_xMax:
						cmdValues.max.x = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.max.x = true;
						break;

					case cmd_yMin:
						cmdValues.min.y = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.min.y = true;
						break;

					case cmd_yMax:
						cmdValues.max.y = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.max.y = true;
						break;

					case cmd_zMin:
						cmdValues.min.z = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.min.z = true;
						break;

					case cmd_zMax:
						cmdValues.max.z = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.max.z = true;
						break;

					case cmd_xWid:
						cmdValues.wid.x = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.wid.x = true;
						break;

					case cmd_yWid:
						cmdValues.wid.y = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.wid.y = true;
						break;

					case cmd_zWid:
						cmdValues.wid.z = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.wid.z = true;
						break;

					case cmd_tiss:
						cmdValues.tiss = parameter;
						cmdFlags.tiss = true;
						break;

					case cmd_geom:
						cmdValues.geom = parameter;
						cmdFlags.geom = true;
						break;

					case cmd_seqn:
						cmdValues.seqn = parameter;
						cmdFlags.seqn = true;
						break;

					case cmd_e1Mins:
						cmdValues.e1Mins.push_back(parameter);
						cmdFlags.e1Mins = cmdFlags.e1Mins || true;
						break;

					case cmd_kNoise:
						cmdValues.kNoise = parameter;
						cmdFlags.kNoise = true;
						break;

					case cmd_NEX:
						cmdValues.NEX = (unsigned short int)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.NEX = true;
						break;

					default:
						std::cout << "\nFATAL ERROR: Map value found that does not exist in switch statement.\n";
						std::cout << "Debug file CmdInterp.cpp, function CmdInterp(int arc, char *argv[]).\n";
						std::cout << "Problem argv input: " << argv[count] << "\nPress enter to quit.\n";
						std::cin.get();
						return false;
						break;
				} /* switch (it->second) */
			} /* if (it == cmdMap.end()) */
		}
		catch (...)
		{	// :TODO: ensure good error report
			std::cout << "\nError: command line option not recognized: \"" << argv[count] << "\"" << std::endl;
			std::cout << "Correct errors and restart simulation.\nPress enter to quit."<< std::endl;
			std::cin.get();
			return false;
		} /* try */
	} /* for (int count = 1; count < argc; count++) */

	return checkFileNames();
} /* bool CmdInterp::interpCmd(int argc, char *argv[]) */

// ------------------------------------------------------------------------------

bool CmdInterp::checkFileNames()
{
	std::fstream fHandle;
	std::string str;

	// ****************************************************************
	// make sure geometry file exists
	str = cmdValues.geom;
	fHandle.open(str.c_str(), std::ios::in | std::ios::binary);
	if (fHandle.fail()) 
	{
		fHandle.close();
		std::cout << "\nError opening geometry file!\n";
		std::cout << "Verify file: " << str << " exists.\n";
		std::cout << "Press enter to quit.";
		std::cin.get();
		return false;
	}
	fHandle.close();

	// ****************************************************************
	// make sure tissue file exists
	str = cmdValues.tiss;
	fHandle.open(str.c_str(), std::ios::in | std::ios::binary);
	if (fHandle.fail()) 
	{
		fHandle.close();
		std::cout << "\nError opening tissue file!\n";
		std::cout << "Verify file: " << str << " exists.\n";
		std::cout << "Press enter to quit.";
		std::cin.get();
		return false;
	}
	fHandle.close();

	// ****************************************************************
	// make sure sequence file exists
	str = cmdValues.seqn;
	fHandle.open(str.c_str(), std::ios::in | std::ios::binary);
	if (fHandle.fail()) 
	{
		fHandle.close();
		std::cout << "\nError opening sequence file!\n";
		std::cout << "Verify file: " << str << " exists.\n";
		std::cout << "Press enter to quit.";
		std::cin.get();
		return false;
	}
	fHandle.close();

	return true;
}

// ------------------------------------------------------------------------------
