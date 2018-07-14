unit Formats;

interface

uses
	FMSEInterfaces;

type
	TRGB = packed record
		R, G, B: byte;
	end;
	PRGB = ^TRGB;

type

	TABCLoader = class(TInterfacedObject, IModelLoader)
	private
	public
		function GetValues(vertices: PInteger; lines: PInteger;
			triangles: PInteger): boolean; stdcall;
		function GetVertices(start, count: integer; data: pointer): boolean; stdcall;
		class function TryLoad(stream: IFileStream; out modelLoader: IModelLoader): boolean;
	end;

	TBMPLoader = class(TInterfacedObject, IImageLoader)
	private
		width, height, bitDepth: integer;
		paletteOffset: integer; // 0 - no palette
		palette: array[byte] of cardinal;
		dataOffset, pitch: integer;
		formatName: PChar;
		stream: IFileStream;
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;

	TPCXLoader = class(TInterfacedObject, IImageLoader)
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;

	TTGALoader = class(TInterfacedObject, IImageLoader)
		width, height: integer;
		stream: IFileStream;
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;

const
	M8_VERSION = 2;
	MIPLEVELS = 16;

type
	TM8Header = packed record
		version: integer;
		name: array[0..31] of char;
		width, height, offsets: array[0..MIPLEVELS - 1] of cardinal;
		animname: array[0..31] of char;
		palette: array[byte] of TRGB;
		flags: integer;
		contents: integer;
		value: integer;
	end;

	TM8Loader = class(TInterfacedObject, IImageLoader)
	private
		width, height, offsets: array[0..MIPLEVELS - 1] of integer;
		palette: array[byte] of cardinal;
		stream: IFileStream;
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;

const
	MIP32_VERSION = 4;
	MIP32_NOMIP_FLAG2 = $00000001;
	MIP32_DETAILER_FLAG2 = $00000002;

type
	TM32Header = packed record
		version: integer;
		name, altname, animname, damagename: array[0..127] of char;
		width, height, offsets: array[0..MIPLEVELS - 1] of integer;
		flags, contents, value: integer;
		scale_x, scale_y: single;
		mip_scale: integer;
		// detail texturing info
		dt_name: array[0..127] of char;
		dt_scale_x, dt_scale_y, dt_u, dt_v, dt_alpha: single;
		dt_src_blend_mode, dt_dst_blend_mode: integer;
		flags2: integer;
		unused: array[0..18] of char; // future expansion to maintain compatibility with h2
	end;

	TM32Loader = class(TInterfacedObject, IImageLoader)
	private
		width, height, offsets: array[0..MIPLEVELS - 1] of integer;
		palette: array[byte] of cardinal;
		stream: IFileStream;
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;


	TDTXLoader = class(TInterfacedObject, IImageLoader)
	private
		palette: array[byte] of cardinal;
		stream: IFileStream;
		width, height: integer;
		bppIdent: smallint;
		bitDepth: byte;
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;


const
	DDS_PALETTE = 1;

type
	TDDSLoader = class(TInterfacedObject, IImageLoader)
	private
		width, height, pitch: cardinal;
		flags: integer;
		stream: IFileStream;
		format: PChar;
		fourCC: array[0..1] of cardinal;
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;

	TMBMLoader = class(TInterfacedObject, IImageLoader)
		width, height: integer;
		flags: cardinal;
		stream: IFileStream;
	public
		class function TryLoad(stream: IFileStream; out imageLoader: IImageLoader): boolean;
		function GetValues(width: PInteger; height: PInteger;
			bitDepth: PInteger): boolean; stdcall;
		function GetFlags(): integer; stdcall;
		function GetFormat(): PChar; stdcall;
		function GetPalette(nColors: PInteger; pal: PPaletteArray4): boolean; stdcall;
		function GetPixels(nLine, nFrom, nCount: integer; pixels: PCardinal): boolean; stdcall;
		function GetRawData(out dataStream: IStream): boolean; stdcall;
		function GetRawData2(size: integer; bits: pointer): boolean; stdcall;
	end;



implementation

uses Windows, DirectDraw, LogProc;

{ TBMPLoader }

function TBMPLoader.GetFlags: integer;
begin
	if paletteOffset <> 0 then
		Result:= IMG_HASPALETTE
	else
		Result:= 0;
end;

function TBMPLoader.GetFormat: PChar;
begin
	Result:= formatName;
end;

function TBMPLoader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
var
	colorsToRead: integer;
begin
	Result:= false;
	if (Self.stream = nil) or (Self.paletteOffset = 0) then begin
		Exit;
	end;
	if (pal <> nil) then begin
		colorsToRead:= 256;
		if (nColors <> nil) and (nColors^ < colorsToRead) then colorsToRead:= nColors^;
		stream.Seek(paletteOffset, 0);
		stream.Read(pal^, colorsToRead);
		Result:= true;
	end;
end;

function TBMPLoader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
var
	p8: PByte;
	p16: PWord;
	p24: PRGB;
begin
	Result:= false;
	if (stream = nil) then Exit;
	if (nLine >= height) then Exit;
	if (nFrom < 0) then begin
		inc(nCount, -nFrom);
		inc(integer(pixels), ((-nFrom) * bitDepth) shr 3);
		nFrom:= 0;
	end;
	if (nFrom + nCount > width) then nCount:= width - nFrom;
	stream.Seek(dataOffset + pitch * nLine + (nFrom * bitDepth) shr 3, 0);
	stream.Read(pixels^, nCount * bitDepth shr 3);
	case bitDepth of
		4: begin
			p8:= pointer(pixels);
			inc(p8, nCount shr 1);
			inc(pixels, nCount);
			while (nCount > 0) do begin
				dec(pixels);
				dec(p8);
				pixels^:= palette[p8^ and $F];
				dec(pixels);
				pixels^:= palette[p8^ shr 4];
				dec(nCount, 2);
			end;
		end;
		8: begin
			p8:= pointer(pixels);
			inc(p8, nCount);
			inc(pixels, nCount);
			while (nCount > 0) do begin
				dec(pixels);
				dec(p8);
				pixels^:= palette[p8^];
				dec(nCount);
			end;
		end;
		16: begin
			p16:= pointer(pixels);
			inc(p16, nCount);
			inc(pixels, nCount);
			while (nCount > 0) do begin
				dec(pixels);
				dec(p16);
				pixels^:= ((p16^ and $F800) shl 8) or ((p16^ and $7E0) shl 5) or ((p16^ and $1F) shl 3);
				dec(nCount);
			end;
		end;
		24: begin
			p24:= pointer(pixels);
			inc(p24, nCount);
			inc(pixels, nCount);
			while (nCount > 0) do begin
				dec(pixels);
				dec(p24);
				pixels^:= (p24.B shl 16) or (p24.G shl 8) or p24.R or $FF000000;
				dec(nCount);
			end;
		end;
	end;
	Result:= true;
end;

function TBMPLoader.GetRawData(out dataStream: IStream): boolean;
begin
	//dataStream:= stream;
	//Result:= (stream <> nil);
	dataStream:= nil;
	Result:= false;
end;

function TBMPLoader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	Result:= false;
end;

function TBMPLoader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	if (stream = nil) then begin
		Result:= false;
		Exit;
	end;
	if (width <> nil) then width^:= Self.width;
	if (height <> nil) then height^:= Self.height;
	if (bitDepth <> nil) then bitDepth^:= Self.bitDepth;
	Result:= true;
end;

class function TBMPLoader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	bmpFileHeader: BITMAPFILEHEADER;
	bmpInfoHeader: BITMAPINFOHEADER;
	bmpLoader: TBMPLoader;
//	i: integer;
begin
	stream.Seek(0, 0);
	stream.Read(bmpFileHeader, sizeof(bmpFileHeader));
	if (bmpFileHeader.bfType <> (Ord('B') or (Ord('M') shl 8))) then begin
		imageLoader:= nil;
		Result:= false;
		Exit;
	end;
	stream.Read(bmpInfoHeader, sizeof(bmpInfoHeader));
	// validation

	bmpLoader:= TBMPLoader.Create;
	bmpLoader.width:= bmpInfoHeader.biWidth;
	bmpLoader.bitDepth:= bmpInfoHeader.biBitCount;
	// 4 byte align
	bmpLoader.pitch:= (((bmpLoader.width * bmpLoader.bitDepth) shr 3) + 3) and (not 3);
	bmpLoader.height:= bmpInfoHeader.biHeight;
	if (bmpLoader.height < 0) then bmpLoader.pitch:= -bmpLoader.pitch;
	bmpLoader.paletteOffset:= 0;
	if (bmpInfoHeader.biClrUsed <> 0) then bmpLoader.paletteOffset:= sizeof(bmpFileHeader) + sizeof(bmpInfoHeader);
	bmpLoader.dataOffset:= bmpFileHeader.bfOffBits;
	bmpLoader.stream:= stream;

	if bmpLoader.bitDepth <= 8 then begin
		stream.Seek(bmpLoader.paletteOffset, 0);
		stream.Read(bmpLoader.palette, 4 shl bmpLoader.bitDepth);
		{for i:= 0 to 1 shl bmpLoader.bitDepth - 1 do
			bmpLoader.palette[i]:= (bmpLoader.palette[i] and $FF00)
				or ((bmpLoader.palette[i] and $FF0000) shr 16)
				or ((bmpLoader.palette[i] and $FF) shl 16)
				or $FF000000;   }
	end;

	imageLoader:= bmpLoader;
	Result:= true;
end;



{ TPCXLoader }

function TPCXLoader.GetFlags: integer;
begin
	Result:= IMG_COMPRESSED;
end;

function TPCXLoader.GetFormat: PChar;
begin
	Result:= 'PAL8';
end;

function TPCXLoader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
begin
	Result:= false;
end;

function TPCXLoader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
begin
	Result:= false;
end;

function TPCXLoader.GetRawData(out dataStream: IStream): boolean;
begin
	dataStream:= nil;
	Result:= false;
end;

function TPCXLoader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	Result:= false;
end;

function TPCXLoader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	Result:= false;
end;

type
	TPCXHeader = packed record
		id: byte; // 10
		version: byte; // 0..5
		encoding: byte; // 1 -> RLE
		bitDepth: byte;
		minX, minY, maxX, maxY: word; // rect?
		horDPI, vertDPI: word;
		colormap: array[0..15] of TRGBTriple; // 16-color palette
		reserved: byte;
		planes: byte; // imagesize = planes * bytesPerLine
		bytesPerLine: word;
		paletteInfo: word;
		screenWidth, screenHeight: word;
		padding: array[0..53] of byte;
	end;


class function TPCXLoader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	header: TPCXHeader;
begin
	imageLoader:= nil;
	Result:= false;
	stream.Seek(0, 0);
	stream.Read(header, sizeof(header));
	if (header.id <> 10) then Exit;
end;


{ TM8Loader }

function TM8Loader.GetFlags: integer;
begin
	Result:= IMG_HASPALETTE;
end;

function TM8Loader.GetFormat: PChar;
begin
	Result:= 'PAL8';
end;

function TM8Loader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
var
	colorsToRead: integer;
begin
	colorsToRead:= 256;
	if (nColors <> nil) then begin
		if (nColors^ < colorsToRead) then
			colorsToRead:= nColors^
		else
			nColors^:= colorsToRead;
	end;
	if (pal <> nil) then Move(palette, pal^, colorsToRead shl 2);
	Result:= true;
end;

function TM8Loader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
var
	p8: PByte;
begin
	Result:= false;
	if (stream = nil) then Exit;
	if (nLine >= height[0]) then Exit;
	nLine:= height[0] - nLine - 1;
	if (nFrom < 0) then begin
		inc(nCount, -nFrom);
		inc(integer(pixels), -nFrom);
		nFrom:= 0;
	end;
	if (nFrom + nCount > width[0]) then nCount:= width[0] - nFrom;
	stream.Seek(offsets[0] + width[0] * nLine + nFrom, 0);
	stream.Read(pixels^, nCount);
	p8:= pointer(pixels);
	inc(p8, nCount);
	inc(pixels, nCount);
	while (nCount > 0) do begin
		dec(pixels);
		dec(p8);
		pixels^:= palette[p8^];
		dec(nCount);
	end;
	Result:= true;
end;

function TM8Loader.GetRawData(out dataStream: IStream): boolean;
begin
	dataStream:= nil;
	Result:= false;
end;

function TM8Loader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	Result:= false;
end;

function TM8Loader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	if width <> nil then width^:= Self.width[0];
	if height <> nil then height^:= Self.height[0];
	if bitDepth <> nil then bitDepth^:= 8;
	Result:= true;
end;

class function TM8Loader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	header: TM8Header;
	i: integer;
	m8: TM8Loader;
	levels: integer;
begin
	Result:= false;
	imageLoader:= nil;
	stream.Seek(0, 0);
	stream.Read(header, sizeof(header));
	if (header.version <> M8_VERSION) then Exit;
	E_LogFormat('Name: "%s", animname: "%s", flags = %08x, contents = %08x, value = %08x',
		[header.name, header.animname, header.flags, header.contents, header.value]);
	levels:= 0;
	for i:= 0 to MIPLEVELS - 1 do begin
		if (header.width[i] <> 0) and (header.height[i] <> 0) then inc(levels) else break;
		E_LogFormat('Mip[%d]: %d x %d at %d', [i, header.width[i], header.height[i], header.offsets[i]]);
	end;
	E_LogFormat('%d mip levels', [levels]);
	m8:= TM8Loader.Create;
	Move(header.width, m8.width, sizeof(m8.width));
	Move(header.height, m8.height, sizeof(m8.height));
	Move(header.offsets, m8.offsets, sizeof(m8.offsets));
	for i:= 0 to 255 do
		m8.palette[i]:= (header.palette[i].R shl 16) or (header.palette[i].G shl 8)
			or header.palette[i].B or $FF000000;
	m8.stream:= stream;
	imageLoader:= m8;
	Result:= true;
end;

{ TM32Loader }

function TM32Loader.GetFlags: integer;
begin
	Result:= 0;
end;

function TM32Loader.GetFormat: PChar;
begin
	Result:= 'XRGB8888';
end;

function TM32Loader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
begin
	Result:= false;
end;

function TM32Loader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
begin
	Result:= false;
	if (stream = nil) then Exit;
	if (nLine >= height[0]) then Exit;
	nLine:= height[0] - nLine - 1;
	if (nFrom < 0) then begin
		inc(nCount, -nFrom);
		inc(integer(pixels), -nFrom);
		nFrom:= 0;
	end;
	if (nFrom + nCount > width[0]) then nCount:= width[0] - nFrom;
	stream.Seek(offsets[0] + (width[0] * nLine + nFrom) shl 2, 0);
	stream.Read(pixels^, nCount shl 2);
	Result:= true;
end;

function TM32Loader.GetRawData(out dataStream: IStream): boolean;
begin
	dataStream:= nil;
	Result:= false;
end;

function TM32Loader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	Result:= false;
end;

function TM32Loader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	if width <> nil then width^:= Self.width[0];
	if height <> nil then height^:= Self.height[0];
	if bitDepth <> nil then bitDepth^:= 8;
	Result:= true;
end;

class function TM32Loader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	header: TM32Header;
	i: integer;
	m32: TM32Loader;
	levels: integer;
begin
	Result:= false;
	imageLoader:= nil;
	stream.Seek(0, 0);
	stream.Read(header, sizeof(header));
	if (header.version <> MIP32_VERSION) then Exit;
	E_LogFormat('Name: "%s", animname: "%s", flags = %08x, contents = %08x, value = %08x',
		[header.name, header.animname, header.flags, header.contents, header.value]);
	levels:= 0;
	for i:= 0 to MIPLEVELS - 1 do begin
		if (header.width[i] <> 0) and (header.height[i] <> 0) then inc(levels) else break;
		E_LogFormat('Mip[%d]: %d x %d at %d', [i, header.width[i], header.height[i], header.offsets[i]]);
	end;
	E_LogFormat('%d mip levels', [levels]);
	m32:= TM32Loader.Create;
	Move(header.width, m32.width, sizeof(m32.width));
	Move(header.height, m32.height, sizeof(m32.height));
	Move(header.offsets, m32.offsets, sizeof(m32.offsets));
	m32.stream:= stream;
	imageLoader:= m32;
	Result:= true;
end;

{ TDTXLoader }

// DTX format:
// DtxHeader
// Texture pixels (for each mipmap)
// 8-bit alpha masks (for each mipmap, if DTX_ALPHAMASKS flag is set)
// 1 if more sections, 0 if no more
//     DtxSection
//     Section data
//     go back to more sections test

const
	DTX_COMMANDSTRING_LEN = 128;

type
	BPPIdent = (
		BPP_8P=0,       // 8 bit palettized
		BPP_8,          // 8 bit RGB
		BPP_16,
		BPP_32,
		BPP_S3TC_DXT1,
		BPP_S3TC_DXT3,
		BPP_S3TC_DXT5,
		BPP_32P,        //this was added for true color pallete support
		BPP_24,
		NUM_BIT_TYPES
	);
	TBPPIdent = BPPIdent;

	TDTXHeader = object
		resType: cardinal;
		version: integer;
		baseWidth, baseHeight: word;
		nMipmaps, nSections: word;
		iFlags: integer;
		userFlags: integer;
		extra: record
			case boolean of
				false: (bytes: array[0..11] of byte);
				true:  (long: array[0..2] of cardinal);
		end;
		commandString: array[0..DTX_COMMANDSTRING_LEN - 1] of char;
	public
		function GetBPPIdent: BPPIdent;
		procedure SetBPPIdent(id: BPPIdent);
	end;

function TDTXHeader.GetBPPIdent: BPPIdent;
begin
	if (extra.bytes[2] = 0) then Result:= BPP_32 else Result:= BPPIdent(extra.bytes[2]);
end;

procedure TDTXHeader.SetBPPIdent(id: BPPIdent);
begin
	extra.bytes[2]:= Ord(id);
end;

const
	LT_RESTYPE_DTX = 0;
	LT_RESTYPE_MODEL = 1;
	LT_RESTYPE_SPRITE = 2;

	CURRENT_DTX_VERSION = -5; // m_Version in the DTX header.


function TDTXLoader.GetFlags: integer;
begin
	Result:= 0;
	if (bppIdent = Ord(BPP_S3TC_DXT1)) or (bppIdent = Ord(BPP_S3TC_DXT3))
		or (bppIdent = Ord(BPP_S3TC_DXT5)) then Result:= Result or IMG_HWFORMAT;
end;

function TDTXLoader.GetFormat: PChar;
begin
	case TBPPIdent(self.bppIdent) of
		BPP_8P: Result:= 'PAL';
		BPP_8: Result:= 'RGB332';
		BPP_16: Result:= 'RGB565'; // add another check!
		BPP_32: Result:= 'XRGB8888';
		BPP_S3TC_DXT1: Result:= 'DXT1';
		BPP_S3TC_DXT3: Result:= 'DXT3';
		BPP_S3TC_DXT5: Result:= 'DXT5';
		//BPP_32P,        //this was added for true color pallete support
		BPP_24: Result:= 'RGB888';
		else Result:= '???';
	end;
end;

function TDTXLoader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
begin
	Result:= false;
end;

function TDTXLoader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
var
	pitch: integer;
begin
	Result:= false;
	if (bppIdent = Ord(BPP_S3TC_DXT1)) or (bppIdent = Ord(BPP_S3TC_DXT3))
		or (bppIdent = Ord(BPP_S3TC_DXT5)) or (bitDepth = 0) then Exit;
	if (stream = nil) then Exit;
	nLine:= height - nLine - 1;
	if (nLine < 0) or (nLine >= height) then Exit;
	if (nFrom < 0) then begin
		inc(nCount, -nFrom);
		inc(integer(pixels), ((-nFrom) * bitDepth) shr 3);
		nFrom:= 0;
	end;
	if (nFrom + nCount > width) then nCount:= width - nFrom;
	pitch:= (width * bitDepth) shr 3;
	stream.Seek(sizeof(TDTXHeader) + pitch * nLine + (nFrom * bitDepth) shr 3, 0);
	stream.Read(pixels^, nCount * bitDepth shr 3);
	Result:= true;
end;

function TDTXLoader.GetRawData(out dataStream: IStream): boolean;
begin
	dataStream:= nil;
	Result:= false;
end;

function TDTXLoader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	Result:= false;
	if (stream = nil) then Exit;
	stream.Seek(sizeof(TDTXHeader), 0);
	stream.Read(bits^, size);
	Result:= true;
end;

function TDTXLoader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	if width <> nil then width^:= Self.width;
	if height <> nil then height^:= Self.height;
	if bitDepth <> nil then
		case TBPPIdent(self.bppIdent) of
			BPP_8P, BPP_8: bitDepth^:= 1;
			BPP_16: bitDepth^:= 2;
			BPP_24: bitDepth^:= 3;
			BPP_32: bitDepth^:= 4;
			else bitDepth^:= 0;
		end;
	Result:= true;
end;

class function TDTXLoader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	header: TDTXHeader;
	dtx: TDTXLoader;
begin
	Result:= false;
	imageLoader:= nil;
	if (stream = nil) then Exit;
	stream.Seek(0, 0);
	stream.Read(header, sizeof(header));
	if (header.resType <> LT_RESTYPE_DTX) then Exit;
	if (header.version <> CURRENT_DTX_VERSION) then Exit;
	if (header.nMipmaps <= 0) or (header.nMipmaps > 15) then Exit;
	dtx:= TDTXLoader.Create;
	dtx.width:= header.baseWidth;
	dtx.height:= header.baseHeight;
	dtx.bppIdent:= Ord(header.GetBPPIdent());
	case header.GetBPPIdent() of
		BPP_8P: dtx.bitDepth:= 8;
		BPP_8:  dtx.bitDepth:= 8;
		BPP_16: dtx.bitDepth:= 16;
		BPP_32: dtx.bitDepth:= 32;
		//BPP_S3TC_DXT1: dtx.bitDepth:= 0;
		//BPP_S3TC_DXT3: dtx.bitDepth:= 0;
		//BPP_S3TC_DXT5: dtx.bitDepth:= 0;
		//BPP_32P,        //this was added for true color pallete support
		BPP_24: dtx.bitDepth:= 24;
		else dtx.bitDepth:= 0;
	end;
	dtx.stream:= stream;
	E_LogFormat('DTX texture: %dx%d, bpp: %d', [dtx.width, dtx.height, Ord(header.GetBPPIdent)]);
	imageLoader:= dtx;
	Result:= true;
end;

{ TDDSLoader }

type
	TDDSHeader = packed record
		dwMagic: DWORD;
		ddsd: DDSURFACEDESC2;
	end;

const
	DDS_MAGIC = $20534444;

function TDDSLoader.GetFlags: integer;
begin
	if pitch = 0 then
		Result:= IMG_HWFORMAT
	else
		Result:= 0;
end;

function TDDSLoader.GetFormat: PChar;
begin
	Result:= format;
end;

function TDDSLoader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
begin
	Result:= false;
end;

function TDDSLoader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
begin
	Result:= false;
end;

function TDDSLoader.GetRawData(out dataStream: IStream): boolean;
begin
	dataStream:= nil;
	Result:= false;
end;

function TDDSLoader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	stream.Seek(sizeof(TDDSHeader), 0);
	stream.Read(bits^, size);
	Result:= true;
end;

function TDDSLoader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	if width <> nil then width^:= Self.width;
	if height <> nil then height^:= Self.height;
	if bitDepth <> nil then bitDepth^:= 0;
	Result:= true;
end;

class function TDDSLoader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	header: TDDSHeader;
	dds: TDDSLoader;
	flags: string;
begin
	Result:= false;
	imageLoader:= nil;
	if (stream = nil) then Exit;
	stream.Seek(0, 0);
	stream.Read(header, sizeof(header));
	E_LogFormat('header.dwMagic: %08x, flags: %08x', [header.dwMagic, header.ddsd.dwFlags]);
	if (header.dwMagic <> DDS_MAGIC) then Exit;

	flags:= '';
	if (header.ddsd.dwFlags and DDSD_CAPS <> 0) then flags:= flags + ' DDSD_CAPS';
	if (header.ddsd.dwFlags and DDSD_HEIGHT <> 0) then flags:= flags + ' DDSD_HEIGHT';
	if (header.ddsd.dwFlags and DDSD_WIDTH <> 0) then flags:= flags + ' DDSD_WIDTH';
	if (header.ddsd.dwFlags and DDSD_PITCH <> 0) then flags:= flags + ' DDSD_PITCH';
	if (header.ddsd.dwFlags and DDSD_BACKBUFFERCOUNT <> 0) then flags:= flags + ' DDSD_BACKBUFFERCOUNT';
	if (header.ddsd.dwFlags and DDSD_ZBUFFERBITDEPTH <> 0) then flags:= flags + ' DDSD_ZBUFFERBITDEPTH';
	if (header.ddsd.dwFlags and DDSD_ALPHABITDEPTH <> 0) then flags:= flags + ' DDSD_ALPHABITDEPTH';
	if (header.ddsd.dwFlags and DDSD_LPSURFACE <> 0) then flags:= flags + ' DDSD_LPSURFACE';
	if (header.ddsd.dwFlags and DDSD_PIXELFORMAT <> 0) then flags:= flags + ' DDSD_PIXELFORMAT';
	if (header.ddsd.dwFlags and DDSD_CKDESTOVERLAY <> 0) then flags:= flags + ' DDSD_CKDESTOVERLAY';
	if (header.ddsd.dwFlags and DDSD_CKDESTBLT <> 0) then flags:= flags + ' DDSD_CKDESTBLT';
	if (header.ddsd.dwFlags and DDSD_CKSRCOVERLAY <> 0) then flags:= flags + ' DDSD_CKSRCOVERLAY';
	if (header.ddsd.dwFlags and DDSD_CKSRCBLT <> 0) then flags:= flags + ' DDSD_CKSRCBLT';
	if (header.ddsd.dwFlags and DDSD_MIPMAPCOUNT <> 0) then flags:= flags + ' DDSD_MIPMAPCOUNT';
	if (header.ddsd.dwFlags and DDSD_REFRESHRATE <> 0) then flags:= flags + ' DDSD_REFRESHRATE';
	if (header.ddsd.dwFlags and DDSD_LINEARSIZE <> 0) then flags:= flags + ' DDSD_LINEARSIZE';
	if (header.ddsd.dwFlags and DDSD_TEXTURESTAGE <> 0) then flags:= flags + ' DDSD_TEXTURESTAGE';
	if (header.ddsd.dwFlags and DDSD_FVF <> 0) then flags:= flags + ' DDSD_FVF';
	if (header.ddsd.dwFlags and DDSD_SRCVBHANDLE <> 0) then flags:= flags + ' DDSD_SRCVBHANDLE';
	if (header.ddsd.dwFlags and DDSD_DEPTH <> 0) then flags:= flags + ' DDSD_DEPTH';
	E_LogFormat('Flags: %s', [flags]);

	if (header.ddsd.dwSize <> sizeof(header.ddsd)) then Exit;
	if (header.ddsd.dwFlags and DDSD_WIDTH = 0)
		or (header.ddsd.dwFlags and DDSD_HEIGHT = 0)
		or (header.ddsd.dwFlags and DDSD_HEIGHT = 0)
		or (header.ddsd.dwFlags and (DDSD_PITCH or DDSD_LINEARSIZE) = 0) then Exit;
	dds:= TDDSLoader.Create;
	dds.width:= header.ddsd.dwWidth;
	dds.height:= header.ddsd.dwHeight;
	if (header.ddsd.dwFlags and DDSD_PITCH <> 0) then
		dds.pitch:= header.ddsd.lPitch
	else
		if (header.ddsd.dwFlags and DDSD_PIXELFORMAT <> 0) then begin
			if (header.ddsd.ddpfPixelFormat.dwFlags and DDPF_RGB <> 0) then
				dds.pitch:= dds.width * header.ddsd.ddpfPixelFormat.dwRGBBitCount div 8
			else begin
				dds.pitch:= 0; // DXT compression
				E_LogFormat('Compressed image: %4s', [PChar(@header.ddsd.ddpfPixelFormat.dwFourCC)]);
				dds.fourCC[0]:= header.ddsd.ddpfPixelFormat.dwFourCC;
				dds.fourCC[1]:= 0;
				dds.format:= @dds.fourCC;
			end
		end else
			dds.pitch:= dds.width;
	E_LogFormat('Pitch: %d', [dds.pitch]);
	dds.stream:= stream;
	imageLoader:= dds;
	Result:= true;
end;

{ TMBMLoader }

type
	TMBMHeader = record
		Header: Cardinal;
		StructVersion: Cardinal;
		Flags: Cardinal;
		Width: Integer;
		Height: Integer;
	end;

const
	MBM_HEADER = $504D424D;
	MBM_VERSION = $01010000;

function TMBMLoader.GetFlags: integer;
begin
	Result:= 0;
end;

function TMBMLoader.GetFormat: PChar;
begin
	Result:= 'XRGB8888';
end;

function TMBMLoader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
begin
	Result:= false;
end;

function TMBMLoader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
var
	pitch: integer;
	bitDepth: integer;
begin
	Result:= false;
	bitDepth:= 32;
	if (stream = nil) then Exit;
	nLine:= height - nLine - 1;
	if (nLine >= height) then Exit;
	if (nFrom < 0) then begin
		inc(nCount, -nFrom);
		inc(integer(pixels), ((-nFrom) * bitDepth) shr 3);
		nFrom:= 0;
	end;
	if (nFrom + nCount > width) then nCount:= width - nFrom;
	bitDepth:= 32;
	pitch:= width * 4;
	stream.Seek(sizeof(TMBMHeader) + pitch * nLine + (nFrom * bitDepth) shr 3, 0);
	stream.Read(pixels^, nCount * bitDepth shr 3);
	Result:= true;
end;

function TMBMLoader.GetRawData(out dataStream: IStream): boolean;
begin
	dataStream:= nil;
	Result:= false;
end;

function TMBMLoader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	stream.Seek(sizeof(TMBMHeader), 0);
	stream.Read(bits^, size);
	Result:= true;
end;

function TMBMLoader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	if width <> nil then width^:= self.width;
	if height <> nil then height^:= self.height;
	if bitDepth <> nil then bitDepth^:= 32;
	Result:= true;
end;

class function TMBMLoader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	header: TMBMHeader;
	mbm: TMBMLoader;
begin
	Result:= false;
	stream.Seek(0, 0);
	stream.Read(header, sizeof(header));
	if header.Header <> MBM_HEADER then Exit;
	if header.StructVersion <> MBM_VERSION then Exit;
	mbm:= TMBMLoader.Create;
	mbm.width:= header.Width;
	mbm.height:= header.Height;
	mbm.flags:= header.Flags;
	mbm.stream:= stream;
	imageLoader:= mbm;
	Result:= true;
end;

{ TTGALoader }

type
	TTGAHeader = packed record
		idLength: byte;
		colourMapType: byte;
		dataTypeCode: byte;
		colourMapOrigin: word;
		colourMapLength: word;
		colourMapDepth: byte;
		xOrigin, yOrigin: smallint;
		width, height: word;
		bitsPerPixel: byte;
		imageDescriptor: byte;
	end;

function TTGALoader.GetFlags: integer;
begin
	Result:= 0;
end;

function TTGALoader.GetFormat: PChar;
begin
	Result:= '';
end;

function TTGALoader.GetPalette(nColors: PInteger;
	pal: PPaletteArray4): boolean;
begin
	Result:= false;
end;

function TTGALoader.GetPixels(nLine, nFrom, nCount: integer;
	pixels: PCardinal): boolean;
begin
	Result:= false;
end;

function TTGALoader.GetRawData(out dataStream: IStream): boolean;
begin
	dataStream:= nil;
	Result:= false;
end;

function TTGALoader.GetRawData2(size: integer; bits: pointer): boolean;
begin
	Result:= false;
end;

function TTGALoader.GetValues(width, height, bitDepth: PInteger): boolean;
begin
	Result:= false;
end;

const
	TGA_NO_IMAGE = 0;       // No image data included.
	TGA_PALETTE = 1;        // Uncompressed, color-mapped images.
	TGA_RGB = 2;            // Uncompressed, RGB images.
	TGA_GRAYSCALE = 3;      // Uncompressed, black and white images.
	TGA_RLE_PALETTE = 9;    // Runlength encoded color-mapped images.
	TGA_RLE_RGB = 10;       // Runlength encoded RGB images.
	TGA_RLE_GRAYSCALE = 11; // Compressed, black and white images.
	TGA_HUFF_PALETTE = 32;  // Compressed color-mapped data, using Huffman, Delta, and
							// runlength encoding.
	TGA_HUFF_PALETTE2 = 33; // Compressed color-mapped data, using Huffman, Delta, and
							// runlength encoding.  4-pass quadtree-type process.

class function TTGALoader.TryLoad(stream: IFileStream;
	out imageLoader: IImageLoader): boolean;
var
	header: TTGAHeader;
begin
	Result:= false;
	if (stream = nil) then Exit;
	stream.Read(header, sizeof(header));

end;

{ TABCLoader }

type
	E_LTB_FILE_TYPES  = (
		LTB_D3D_MODEL_FILE          = 1,
		LTB_PS2_MODEL_FILE          = 2,
		LTB_XBOX_MODEL_FILE         = 3,
		LTB_ABC_MODEL_FILE          = 4,
		LTB_D3D_RENDERSTYLE_FILE    = 5,
		LTB_PS2_RENDERSTYLE_FILE    = 6,
		LTB_D3D_RENDEROBJECT_FILE	= 7
	);

	TLTBHeader = packed record
		fileType: byte;
		version: word;
		reserved1: byte;
		reserved2, reserved3, reserved4: cardinal;
	end;

function TABCLoader.GetValues(vertices, lines,
	triangles: PInteger): boolean;
begin
	Result:= false;
end;

function TABCLoader.GetVertices(start, count: integer;
	data: pointer): boolean;
begin
	Result:= false;
end;

class function TABCLoader.TryLoad(stream: IFileStream;
	out modelLoader: IModelLoader): boolean;
var
	header: TLTBHeader; // ABC = {LTB, ...} ?
begin
	Result:= false;
	if (stream = nil) then Exit;
	modelLoader:= nil;
end;

end.

