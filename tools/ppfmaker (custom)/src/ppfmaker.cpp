/******************************************************************************
ppfmaker.cpp
Pyriel

This is a quick and dirty, custom implementation of the Playstation Patch
Format (ppf).  Notably it includes a 32-bit offset instead of 64, and adds
support for adding data to the end of files.  The latter is necessary for
translations, and the former is a limitation of the Lua patcher (no native 
support for 64-bit types).

PPF was chosen mostly because it was easy to implement later in Lua.

Adding data is a fairly simple affair, and running an already expanded file
through a second time will cause the file to be expanded again with duplicated
data.

The patch header contains PPF40 which is not used by other tools, and will
hopefully prevent individual files from being seen as patches that tools like
PPFomatic could apply.
******************************************************************************/

#include <stdio.h>
#include <memory.h>

typedef signed char		s8;
typedef unsigned char	u8;
typedef signed short	s16;
typedef unsigned short	u16;
typedef signed int		s32;
typedef	unsigned int	u32;

#define PATCH_FILEID_SIZE	5
#define PATCH_DESC_SIZE		50
#define PATCH_DATA_MAXSIZE	255

enum
{
	PATCH_CMD_REPLACE,
	PATCH_CMD_ADD
};


struct PatchHeader
{
public:
	char	file_id[PATCH_FILEID_SIZE];
	u8		encoding;
	char	description[PATCH_DESC_SIZE];
	u8		image_type;
	u8		validation_flag;
	u8		undo_flag;
	u8		expansion;

	PatchHeader()
	{
		memcpy(file_id, "PPF40", PATCH_FILEID_SIZE);
		encoding = 0xFF;
		memset(description, 0, PATCH_DESC_SIZE);
		image_type = 0;
		validation_flag = 0;
		undo_flag = 0;
		expansion = 0;
	};

	void Serialize(FILE *output)
	{
		fwrite(file_id, PATCH_FILEID_SIZE, 1, output);
		fwrite(&encoding, sizeof(encoding), 1, output);
		fwrite(description, PATCH_DESC_SIZE, 1, output);
		fwrite(&image_type, sizeof(image_type), 1, output);
		fwrite(&validation_flag, sizeof(validation_flag), 1, output);
		fwrite(&undo_flag, sizeof(undo_flag), 1, output);
		fwrite(&expansion, sizeof(expansion), 1, output);
	};
};

struct PatchData
{
public:
	u8		command;
	u32		offset;
	u8		size;
	u8		data[PATCH_DATA_MAXSIZE];

	PatchData()
	{
		Reset();
	};

	void Reset()
	{
		command = 0;
		offset = 0;
		size = 0;
		memset(data, 0, PATCH_DATA_MAXSIZE);
	};

	void Serialize(FILE *output)
	{
		fwrite(&command, sizeof(command), 1, output);
		fwrite(&offset, sizeof(offset), 1, output);
		fwrite(&size, sizeof(size), 1, output);
		for(int i = 0; i < size; i++)
		{
			fputc(data[i], output);
		}
		return;
	};
};

void PrintHelp()
{
	printf("Usage:\n  ppfmaker <patch file name> <updated file name> <original file name>\n\n" \
		"Original will be compared to Update, and differences will be captured in the\nPatch file.\n");
	return;
}

int main (int argc, char *argv[])
{
#ifndef _DEBUG
	if(argc == 1)
	{
		PrintHelp();
		return 0;
	}
	if(argc != 4)
	{
		printf("Too few arguments provided.  Specify a patch file to create and the updated and original files for comparison.");
		PrintHelp();
		return 0;
	}
#endif

	FILE *updated, *original, *patch;
#if _DEBUG
	updated = fopen("UWASA1patched.BIN", "rb");
#else
	updated = fopen(argv[2], "rb");
#endif
	if(!updated)
	{
		printf("Error opening updated file %s", argv[2]);
		return 0;
	}

#if _DEBUG
	original = fopen("UWASA1.BIN", "rb");
#else
	original = fopen(argv[3], "rb");
#endif
	if(!original)
	{
		printf("Error opening original file %s", argv[3]);
		return 0;
	}

#if _DEBUG
	patch = fopen("uwasa_1.ppf", "wb");
#else
	patch = fopen(argv[1], "wb");
#endif
	if(!patch)
	{
		printf("Error opening patch file %s", argv[1]);
		return 0;
	}

	PatchHeader header;
	header.Serialize(patch);

	PatchData pd;
	u8 updbyte, origbyte;
	fread(&updbyte, 1, 1, updated);
	fread(&origbyte, 1, 1, original);
	while(!feof(updated))
	{
		if(!feof(original))
		{
			if(origbyte != updbyte)
			{
				if(pd.command != 0)
				{
					printf("Critical Error:  Difference found, but command is add.\n");
					return 0;
				}
				if(pd.size == 0) pd.offset = ftell(original) - 1;
				pd.data[pd.size] = updbyte;
				pd.size++;
				if(pd.size == PATCH_DATA_MAXSIZE)
				{
					pd.Serialize(patch);
					pd.Reset();
				}
			}
			else if(pd.size > 0)
			{
				pd.Serialize(patch);
				pd.Reset();
			}
			fread(&origbyte, 1, 1, original);
			fread(&updbyte, 1, 1, updated);
		}
		else
		{
			// process remainder of updated data as additions
			if(pd.size > 0)
			{
				pd.Serialize(patch);
			}
			pd.Reset();
			pd.command = PATCH_CMD_ADD;

			while(!feof(updated))
			{
				pd.data[pd.size] = updbyte;
				pd.size++;
				if(pd.size == PATCH_DATA_MAXSIZE)
				{
					pd.Serialize(patch);
					pd.Reset();
					pd.command = PATCH_CMD_ADD;
				}
				fread(&updbyte, 1, 1, updated);
			}
			if(pd.size > 0 && pd.size < PATCH_DATA_MAXSIZE)
			{
				pd.Serialize(patch);
			}
		}
	}
	if(pd.size > 0 && pd.size < PATCH_DATA_MAXSIZE)
	{
		pd.Serialize(patch);
	}

	fclose(patch);
	fclose(updated);
	fclose(original);

	return 0;
}