' ########################################################################################
' File: cPDF.bi
' Contents: Create PDF
' Version: 1.0
' Compiler: FreeBasic 32 & 64-bit
' Copyright (c) 2026 Rick Kelly
' Credits: AFXNova by Jose Roca at: https://github.com/JoseRoca/AfxNova
'          Tiko Editor by Paul Squires at https://github.com/PaulSquires
' Released into the public domain for private and public use without restriction
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

' ########################################################################################
' cPDF Class
' ########################################################################################

#DEFINE UNICODE
#DEFINE _WIN32_WINNT &h0602

#INCLUDE ONCE "AfxNova\AfxGdiPlus.inc"
#INCLUDE ONCE "AfxNova\CDicObj.inc"
#INCLUDE ONCE "AfxNova\AfxArrays.inc"
#INCLUDE ONCE "AfxNova\AfxStr.inc"
#INCLUDE ONCE "AfxNova\DVariant.inc"
#INCLUDE ONCE "AfxNova\RGB_Colors.bi"
#INCLUDE ONCE "AfxNova\CFileSys.inc"
#INCLUDE ONCE "AfxNova\AfxCOM.inc"
#INCLUDE ONCE "AfxNova\AfxPath.inc"
#INCLUDE ONCE "AfxNova\AfxGdiPlus.inc"
#INCLUDE ONCE "win\ShellApi.bi"
#INCLUDE ONCE "String.bi"

Namespace cPDFClass

' =====================================================================================
' Defines and Structures
' =====================================================================================

' Supported Font Families

Private Const FONT_ARIAL                         = 1
Private Const FONT_VERDANA                       = 2
Private Const FONT_TREBUCHET                     = 3
Private Const FONT_CALIBRI                       = 4
Private Const FONT_CONSOLAS                      = 5
Private Const FONT_TIMESNEWROMAN                 = 6

' Font Attributes

Private Const PDF_FONT_NORMAL                    = 1
Private Const PDF_FONT_BOLD                      = 2
Private Const PDF_FONT_ITALIC                    = 3
Private Const PDF_FONT_BOLDITALIC                = 4
Private Const FONT_UNDERLINE                     = 1
Private Const FONT_TYPE1                         = 1
Private Const FONT_TRUETYPE                      = 2

' Paper sizes (Do not change, they are indices created by PaperTypes()

Private Const PDF_PAPER_A0                       = 1
Private Const PDF_PAPER_A1                       = 2
Private Const PDF_PAPER_A2                       = 3
Private Const PDF_PAPER_A4                       = 5
Private Const PDF_PAPER_A5                       = 6
Private Const PDF_PAPER_A6                       = 7
Private Const PDF_PAPER_A7                       = 8
Private Const PDF_PAPER_A8                       = 9
Private Const PDF_PAPER_B0                       = 10
Private Const PDF_PAPER_B1                       = 11
Private Const PDF_PAPER_B2                       = 12
Private Const PDF_PAPER_B3                       = 13
Private Const PDF_PAPER_B4                       = 14
Private Const PDF_PAPER_B5                       = 15
Private Const PDF_PAPER_B6                       = 16
Private Const PDF_PAPER_B7                       = 17
Private Const PDF_PAPER_B8                       = 18
Private Const PDF_PAPER_B9                       = 19
Private Const PDF_PAPER_B10                      = 20
Private Const PDF_PAPER_C2                       = 21
Private Const PDF_PAPER_C3                       = 22
Private Const PDF_PAPER_C4                       = 23
Private Const PDF_PAPER_C5                       = 24
Private Const PDF_PAPER_C6                       = 25
Private Const PDF_PAPER_LETTER                   = 26
Private Const PDF_PAPER_LEGAL                    = 27
Private Const PDF_PAPER_LEDGER                   = 28
Private Const PDF_PAPER_TABLOID                  = 29
Private Const PDF_PAPER_EXECUTIVE                = 30
Private Const PDF_PAPER_ANSI_C                   = 31
Private Const PDF_PAPER_ANSI_D                   = 32
Private Const PDF_PAPER_ANSI_E                   = 33
Private Const PDF_PAPER_FOOLSCAP                 = 34
Private Const PDF_PAPER_SMALLCAP                 = 35
Private Const PDF_PAPER_SHEET_ONETHIRD           = 36
Private Const PDF_PAPER_SHEET_ONEHALF            = 37
Private Const PDF_PAPER_DEMY                     = 38
Private Const PDF_PAPER_LARGEPOST                = 39
Private Const PDF_PAPER_SMALLMEDIUM              = 40
Private Const PDF_PAPER_MEDIUM                   = 41
Private Const PDF_PAPER_SMALLROYAL               = 42
Private Const PDF_PAPER_ROYAL                    = 43
Private Const PDF_PAPER_IMPERIAL                 = 44
Private Const PDF_PAPER_METRIC_CROWN_QUARTO      = 45
Private Const PDF_PAPER_METRIC_CROWN_OCTAVO      = 46
Private Const PDF_PAPER_METRIC_LARGECROWN_QUARTO = 47
Private Const PDF_PAPER_METRIC_LARGECROWN_OCTAVO = 48
Private Const PDF_PAPER_METRIC_DEMY_QUARTO       = 49
Private Const PDF_PAPER_METRIC_DEMY_OCTAVO       = 50
Private Const PDF_PAPER_METRIC_ROYAL_QUARTO      = 51
Private Const PDF_PAPER_METRIC_ROYAL_OCTAVO      = 52

' Page Orientations

Private Const PDFPAGE_PORTRAIT                   = 1
Private Const PDFPAGE_LANDSCAPE                  = 2

' PDF Measurement Units per Inch

Private Const PDF_MEASUREMENT                    = 72
Private Const PDF_MM_TO_POINTS                   = 1
Private Const PDF_INCHES_TO_POINTS               = 2
Private Const PDF_POINTS_TO_MM                   = 3
Private Const PDF_POINTS_TO_INCHES               = 4
Private Const PDF_ONE_QUARTER_INCH               = 18

' Line Characterists

Private Const PDF_LINECAP_BUTT                   = 1
Private Const PDF_LINECAP_ROUND                  = 2
Private Const PDF_LINECAP_PROJECTING_SQUARE      = 3
Private Const PDF_LINEJOIN_MITER                 = 4
Private Const PDF_LINEJOIN_ROUND                 = 5
Private Const PDF_LINEJOIN_BEVEL                 = 6

' Justication Control

Private Const TEXT_NEXT_LINE                     = 1
Private Const TEXT_JUSTIFY_LEFT                  = 2
Private Const TEXT_JUSTIFY_CENTER                = 3
Private Const TEXT_JUSTIFY_RIGHT                 = 4
Private Const TEXT_VERTICAL_TOP                  = 5
Private Const TEXT_VERTICAL_CENTER               = 6
Private Const TEXT_VERTICAL_BOTTOM               = 7


Private Const TEXTRENDERING_FILL                     = 0
Private Const TEXTRENDERING_STROKE                   = 1
Private Const TEXTRENDERING_FILLADDSTROKE            = 2
Private Const TEXTRENDERING_INVISIBLE                = 3
Private Const TEXTRENDERING_FILLADDCLIPPING          = 4
Private Const TEXTRENDERING_STROKEADDCLIPPING        = 5
Private Const TEXTRENDERING_FILLAndSTROKEADDCLIPPING = 6
Private Const TEXTRENDERING_ADDCLIPPING              = 7

' Viewer Preferences

Private Const PDF_ZOOM_NONE                      = 0
Private Const PDF_ZOOM_FULLPAGE                  = 1
Private Const PDF_ZOOM_FULLWIDTH                 = 2
Private Const PDF_ZOOM_REAL                      = 3

Private Const PDF_LAYOUT_NONE                    = 0
Private Const PDF_LAYOUT_SINGLE                  = 1
Private Const PDF_LAYOUT_CONTINUOUS              = 2
Private Const PDF_LAYOUT_TWOCOLUMN               = 3

Private Const PDF_VIEWER_USE_THUMBNAILS          = 1

Private Const PDF_VIEWER_HIDEMENUBAR             = 1
Private Const PDF_VIEWER_HIDETOOLBAR             = 1
Private Const PDF_VIEWER_SHOWTITLE               = 1
Private Const PDF_VIEWER_HIDEWINDOWUI            = 1
Private Const PDF_VIEWER_CENTER_WINDOW           = 1
Private Const PDF_VIEWER_FIT_WINDOW              = 1

' Text Lines Spacing (Percentage of Font size)

Private Const PDF_SPACING_SINGLE                 = 100
Private Const PDF_SPACING_SINGLE_ONE_QUARTER     = 125
Private Const PDF_SPACING_SINGLE_ONE_HALF        = 150
Private Const PDF_SPACING_DOUBLE                 = 200

' Miscellaneous

Private Const ITEM_IGNORE                        = -1

' Structures

Type PageMetrics
    Width               AS DOUBLE
    Height              AS DOUBLE
    LeftMargin          AS DOUBLE
    TopMargin           AS DOUBLE
    RightMargin         AS DOUBLE
    BottomMargin        AS DOUBLE
    DrawingHeight       AS DOUBLE
    DrawingWidth        AS DOUBLE
    Orientation         AS LONG
End Type
   

Type PageCanvas
    Width               AS DOUBLE
    Height              AS DOUBLE
    LeftMargin          AS DOUBLE
    TopMargin           AS DOUBLE
    RightMargin         AS DOUBLE
    BottomMargin        AS DOUBLE
    DrawingHeight       AS DOUBLE
    DrawingWidth        AS DOUBLE
    Orientation         AS LONG
    ObjectNumber        AS LONG
    StreamObject        AS LONG
    StreamComplete      AS BOOLEAN
End Type

Type LineDash
    Array1              AS WSTRING * 15
    Phase               AS DOUBLE
End Type

Type LineDescriptor
    Color               AS LONG
    Width               AS DOUBLE
    Cap                 AS LONG
    Join                AS LONG
    Miter               AS DOUBLE
    dash                AS LineDash
End Type

Type TextDescriptor
    FontID              AS WSTRING * 6
    FontSize            AS LONG
    FontColor           AS LONG
    Angle               AS DOUBLE
    Justify             AS LONG
    Underline           AS LONG
    NewLine             AS LONG
    WordSpacing         AS DOUBLE
    CharSpacing         AS DOUBLE
    LineDescriptor      AS LineDescriptor       'Used if text is underlined
End Type

Type ImageOptions
    ScalingPercent      AS DOUBLE
    RotationAngle       AS DOUBLE
    XSkewAngle          AS DOUBLE
    YSkewAngle          AS DOUBLE
End Type

Type FontDescriptor
    FontName                AS WSTRING * 30
    FontID                  AS LONG
    FontStyle               AS LONG
    FontReferenced          AS LONG
    FontStandard            AS LONG
    FontType                AS LONG
    FontAscent              AS LONG
    FontCapHeight           AS LONG
    FontDescent             AS LONG
    FontFlags               AS LONG
    FontRectLeft            AS LONG
    FontRectTop             AS LONG
    FontRectRight           AS LONG
    FontRectBottom          AS LONG
    FontItalicAngle         AS DOUBLE
    FontStemV               AS LONG
    FontWeight              AS LONG
    FontUnderlineThickness  AS LONG
    FontUnderlinePosition   AS LONG
    FontObject              AS LONG
    FontWidthObject         AS LONG
    FontDescriptorObject    AS LONG
    FontCharSpacingAdjust   AS DOUBLE
End Type

Type RectangleDescriptor
    Height              AS DOUBLE
    Width               AS DOUBLE
    FillColor           AS LONG
    Radius              AS DOUBLE
    Corners             AS RECT
    LineAttributes      AS LineDescriptor
End Type

Type MultiLineTextDescriptor
    Height              AS DOUBLE
    Width               AS DOUBLE
    VerticalAlignment   AS LONG
    Spacing             AS DOUBLE
    TextAttributes      AS TextDescriptor
End Type

Type ImageAttributes
    ImageName               AS WSTRING * MAX_PATH
    HorizontalResolution    AS REAL
    VerticalResolution      AS REAL
    ImagePixelHeight        AS UINT
    ImagePixelWidth         AS UINT
    ImageHeight             AS DOUBLE
    ImageWidth              AS DOUBLE
    ImageSize               AS LONG
    ImageDescriptorObject   AS LONG
    ImageReferenced         AS BOOLEAN
End Type

Type OutlineMarker
    PageObject              AS LONG
    ObjectID                AS LONG
    ParentID                AS LONG
    PreviousID              AS LONG
    FirstID                 AS LONG
    NextID                  AS LONG
    LastID                  AS LONG
    ItemCount               AS LONG
    StringID                AS WSTRING * 6
End Type

Type PlaceHolderObject
    ID                      AS WSTRING * MAX_PATH
    ObjectID                AS WSTRING * 6
End Type

Type ReportRow
   Height                   AS LONG
   Margins                  AS RECT
   StringID                 AS WString * 6
   TextDescriptor           AS TextDescriptor
   VerticalAlignment        AS LONG
End Type

End Namespace

USING cPDFClass

' ########################################################################################
' cPDF Class
' ########################################################################################

Type cPDF Extends Object

   Private:

Type PDFPaper
   sPaperName               AS WSTRING * 30
   nPaperHeight             AS DOUBLE
   nPaperWidth              AS DOUBLE
End Type

Type PDFStringID
   sStringID     AS DWSTRING
   sStringText   AS DWSTRING
End Type

Type FontIDWidths
   sFontID     AS DWSTRING
   sFontWidths AS DWSTRING
End Type

Type PDFFontID
   sFontID     AS DWSTRING
   uFont       AS FontDescriptor
End Type

Type PDFFontEmbed
   sFontID             AS DWSTRING
   nFontObject         AS LONG
   nUncompressedSize   AS ULONG
   nCompressedSize     AS ULONG
   sCompressedFont     AS STRING
End Type

Type PDFImageID
   sImageID      AS DWSTRING
   uImage        AS ImageAttributes
End Type

Type OutlineSection                ' Only one section per page supported
   arCanvasIndex AS LONG
   StreamID      AS LONG           ' Points to canvas stream object
   ObjectID      AS LONG           ' Section object ID
   ParentID      AS LONG           ' Points to root outline object
   PreviousID    AS LONG           ' Points to previous section
   FirstID       AS LONG           ' Points to first subsection
   LastID        AS LONG           ' Points to last subsection
   NextID        AS LONG           ' Next Section on another page
   Count         AS LONG           ' Postive Number for subsections, -1 for none
   SectionIndex  AS LONG           ' Used by subsections to link to section
   StringID      AS WString * 10   ' Used to retrieve section display value
End Type

Type ReportTemplate
   TemplateID   AS WSTRING * 6
   X            AS DOUBLE
   Y            AS DOUBLE
   Justify      AS LONG
   Margins      AS RECT
   Rectangle    AS RectangleDescriptor
End Type 

Type ReportHeaderTemplate
   TemplateID   AS WSTRING * 6
   Margins      AS RECT
   Rectangle    AS RectangleDescriptor
End Type

Type ReportColumnHeaderTemplate
   TemplateID   AS WSTRING * 6
   Margins      AS RECT
   Rectangle    AS RectangleDescriptor
End Type

Type ReportHeaderText
   TemplateID      AS WSTRING * 6
   StringID        AS WSTRING * 6
   X               AS DOUBLE
   Y               AS DOUBLE
   TextDescriptor  AS TextDescriptor
End Type

Type ReportColumns
   TemplateID         AS WSTRING * 6
   StringID           AS WSTRING * 6
   Margins            AS RECT
   Rectangle          AS RectangleDescriptor
   TotalWidth         AS LONG
   TextDescriptor     AS TextDescriptor
   VerticalAlignment  AS LONG
   OddLineFillColor   AS LONG
   EvenLineFillColor  AS LONG
End Type

   arPlaceHolderObject(ANY)           AS PlaceHolderObject
   arCanvas(ANY)                      AS PageCanvas
   arStringID(ANY)                    AS PDFStringID
   arFontID(ANY)                      AS PDFFontID
   arFontWidths(ANY)                  AS FontIDWidths
   arImageID(ANY)                     AS PDFImageID
   arReportTemplate(ANY)              AS ReportTemplate
   arReportHeaderTemplate(ANY)        AS ReportHeaderTemplate
   arReportColumnHeaderTemplate(ANY)  AS ReportColumnHeaderTemplate
   arReportColumns(ANY)               AS ReportColumns
   arReportHeaderText(ANY)            AS ReportHeaderText
   arImageStream(ANY)                 AS STRING
   arSection(ANY)                     AS OutlineSection
   arSubsection(ANY)                  AS OutlineSection
   arFontEmbed(ANY)                   AS PDFFontEmbed
   hZlib                              AS HMODULE
   ZLibCompress                       AS FUNCTION (BYVAL sDestination AS ANY PTR, BYREF nDestinationLen AS ULONG, BYVAL sSource AS ANY PTR, BYVAL nSourceLen AS ULONG) AS LONG
   ZLIBCompressBound                  AS FUNCTION (BYVAL sourceLen AS ULONG) AS ULONG
   nCurrentObjectNumber               AS LONG
   nDefaultFontSize                   AS LONG = 12
   nDefaultFontColor                  AS LONG = RGB_BLACK
   nBezierMagic                       AS DOUBLE = ((SQR(2) - 1) / 3) * 4
   nPDF_ZOOM                          AS LONG = PDF_ZOOM_FULLPAGE
   nPDF_LAYOUT                        AS LONG = PDF_LAYOUT_SINGLE
   nCurrentPaperID                    AS LONG = PDF_PAPER_LETTER
   nCurrentPaperOrientation           AS LONG = PDFPAGE_PORTRAIT
   nCurrentWidth                      AS DOUBLE = 612
   nCurrentHeight                     AS DOUBLE = 792 
   nCurrentTopMargin                  AS DOUBLE = PDF_ONE_QUARTER_INCH
   nCurrentLeftMargin                 AS DOUBLE = PDF_ONE_QUARTER_INCH
   nCurrentBottomMargin               AS DOUBLE = PDF_ONE_QUARTER_INCH
   nCurrentRightMargin                AS DOUBLE = PDF_ONE_QUARTER_INCH
   nPageCharacterSpacing              AS DOUBLE = ITEM_IGNORE
   nPageWordSpacing                   AS DOUBLE = ITEM_IGNORE
   nPageHorizontalScaling             AS WORD = 100
   nPageTextLeading                   AS DOUBLE = ITEM_IGNORE
   PI                                 AS DOUBLE = 3.141592653589793
   nPageRenderingMode                 AS LONG = TEXTRENDERING_FILL
   nNextStringID                      AS LONG = 1
   nPDF_VIEWER_USE_THUMBNAILS         AS LONG = 0
   nPDF_VIEWER_HIDEMENUBAR            AS LONG = 0
   nPDF_VIEWER_HIDETOOLBAR            AS LONG = 0
   nPDF_VIEWER_SHOWTITLE              AS LONG = 0
   nPDF_VIEWER_HIDEWINDOWUI           AS LONG = 0
   nPDF_VIEWER_CENTER_WINDOW          AS LONG = 0
   nPDF_VIEWER_FIT_WINDOW             AS LONG = 0
   nTotalFonts                        AS LONG = 0
   sPDFStream                         AS STRING
   sTempStream                        AS STRING
   sProducer                          AS DWSTRING = "cPDF with Jose Roca AfxNova"
   sAuthor                            AS DWSTRING
   sCreator                           AS DWSTRING
   sSubject                           AS DWSTRING
   sTitle                             AS DWSTRING
   sKeywords                          AS DWSTRING
   sDefaultFontID                     AS DWSTRING = "F0"
   sCurrentPaperName                  AS DWSTRING = "Letter"
   sLastErrorDescription              AS DWSTRING
   oObjectOffsetList                  AS DVarList
   oPageStreamList                    AS DWStrList
   oImageDescriptor                   AS CDicObj
   oImageStream                       AS CDicObj
   oPaperList                         AS CDicObj


DECLARE SUB PaperTypes()
DECLARE SUB SaveOffset(BYVAL nOffset AS ULONG)
DECLARE SUB CreateCanvas(BYREF uCanvas As PageCanvas)
DECLARE SUB GetCanvas(BYVAL nIndex AS LONG,BYREF uCanvas AS PageCanvas)
DECLARE SUB GetCurrentCanvas(BYREF uCanvas AS PageCanvas)
DECLARE SUB BuildObject(BYREF sObject AS STRING, BYVAL sObjectPart AS STRING)
DECLARE SUB SaveGraphicsState()
DECLARE SUB RestoreGraphicsState()
DECLARE SUB PDFLineJoin(BYVAL nLineJoin AS LONG)
DECLARE SUB PDFLineCap(BYVAL nLineJoin AS LONG)
DECLARE SUB PDFLineWidth(BYVAL nWidth AS DOUBLE)
DECLARE SUB StringReplace(BYREF sText As DWSTRING, BYVAL sMatch AS DWSTRING, BYVAL sReplace AS DWSTRING)
DECLARE FUNCTION FormatPoint(BYVAL nPoint AS DOUBLE) AS DWSTRING
DECLARE SUB PDFLineDash(BYREF uDash AS LineDash)
DECLARE SUB PDFLineMiter(BYREF nMiter AS DOUBLE)
DECLARE SUB DrawingPoints(BYREF uCanvas As PageCanvas, BYREF nX AS DOUBLE, BYREF nY AS DOUBLE)
DECLARE SUB SetStrokingColor(ByVAL nColor AS LONG)
DECLARE SUB SetNonStrokingColor(ByVAL nColor AS LONG)
DECLARE FUNCTION RGB2PDFColor(BYVAL nRGB AS LONG) AS DWSTRING
DECLARE SUB PDFLineAttributes(BYREF uLine AS LineDescriptor)
DECLARE SUB PDFPathStroke(BYVAL nClosePath AS CONST LONG = 0)
DECLARE SUB PDFPathFillAndStroke(BYVAL nClosePath AS CONST LONG = 0)
DECLARE SUB PDFCurve(BYVAL nX1Control AS DOUBLE, BYVAL nY1Control AS DOUBLE, BYVAL nX2Control AS DOUBLE, _
                     BYVAL nY2Control AS DOUBLE, BYVAL nXEnd AS DOUBLE, BYVAL nYEnd AS DOUBLE)
DECLARE SUB PDFSquareRectangle(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, _
                               BYVAL nWidth AS DOUBLE, BYVAL nFillColor AS LONG, BYREF uLine As LineDescriptor)
DECLARE SUB PDFRoundedRectangle(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, BYVAL nWidth AS DOUBLE, _
                                BYVAL nFillColor As Long, BYREF uLine As LineDescriptor, _
                                BYVAL nRadius AS DOUBLE, BYREF uCorners AS RECT)
DECLARE SUB PDFNewSubPath(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE)
DECLARE SUB PDFStartLine(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uLine As LineDescriptor)
DECLARE SUB PDFMoveTo(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE)
DECLARE SUB PDFFontWidths(BYREF sFontID AS DWSTRING, arWidths() AS LONG)
DECLARE FUNCTION PDFMultiLineInsertWord(BYREF sFontID AS DWSTRING, _
                                        BYVAL nFontSize AS LONG, _
                                        BYVAL nWidth AS LONG, _
                                        BYVAL sWord AS DWSTRING, _
                                        BYREF sLine AS DWSTRING) AS LONG
DECLARE SUB PDFGetFontMetrics(BYREF sFontID AS DWSTRING, BYREF uDescriptor AS FontDescriptor)
DECLARE FUNCTION PDFCenterString(BYREF sString AS DWSTRING, BYVAL nPoint AS DOUBLE, _
                                 BYREF sFontID AS DWSTRING, BYVAL nFontSize AS LONG) AS DOUBLE
DECLARE SUB PDFBeginText()
DECLARE SUB PDFEndText()
DECLARE SUB PDFTextFont(BYVAL sFontID AS DWSTRING, BYVAL nFontSize AS LONG)
DECLARE SUB PDFTextLocation(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nAngle AS CONST LONG = -1, BYVAL nSet AS CONST LONG = 0)
DECLARE SUB PDFAddText(BYREF sText AS DWSTRING, BYVAL nX AS LONG, BYVAL nNewLine AS CONST LONG = -1)
DECLARE SUB PDFTextMoveTo(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, ByVal nSet AS CONST LONG = 0)
DECLARE SUB PDFShowText(BYREF sText AS DWSTRING)
DECLARE SUB PDFTextRotateStream(BYVAL nAngle AS DOUBLE, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE)
DECLARE SUB RotationMatrix(BYVAL nAngle AS DOUBLE, BYREF nA AS DOUBLE, BYREF nB AS DOUBLE, BYREF nC AS DOUBLE, BYREF nD AS DOUBLE)
DECLARE SUB PDFTextNewLine()
DECLARE SUB EndStream()
DECLARE SUB UpdateCurrentCanvas(BYREF uCanvas AS PageCanvas)
DECLARE SUB UpdateCanvas(BYVAL nIndex AS LONG, BYREF uCanvas AS PageCanvas)
DECLARE SUB ReplacePlaceHolders(BYVAL nCurrentPageNumber AS LONG, BYVAL nTotalPages AS LONG)
DECLARE FUNCTION GetStringID(BYREF sStringID AS DWSTRING) AS DWSTRING
DECLARE SUB PDFCompressStream(BYVAL nObjectID AS LONG, BYREF sUncompressed AS STRING, BYREF sStreamObject AS STRING)
DECLARE FUNCTION PDFFlateCompress (BYREF sUncompressed AS STRING, BYREF sCompressed AS STRING) AS BOOLEAN
DECLARE SUB StartStream()
DECLARE SUB PDFTextSpacing(BYVAL nCharacterSpacing AS DOUBLE)
DECLARE SUB PDFTextWordSpacing(BYVAL nWordSpacing AS DOUBLE)
DECLARE SUB PDFTextHorizontalScaling(BYVAL nHorizontalScaling AS WORD)
DECLARE SUB PDFTextLeading(BYVAL nLeading AS DOUBLE)
DECLARE SUB PDFTextRenderingMode(BYVAL nRendering AS LONG)
DECLARE SUB PDFTextRise(BYVAL nRise AS DOUBLE)
DECLARE FUNCTION PDFDocumentID() AS DWSTRING
DECLARE SUB PDFResetFonts()
DECLARE SUB CreateConsolasFont()
DECLARE SUB CreateArialFont()
DECLARE SUB CreateVerdanaFont()
DECLARE SUB CreateTrebuchetFont()
DECLARE SUB CreateCalibriFont()
DECLARE SUB CreateTimesNewRomanFont()
DECLARE SUB SkewMatrix (BYVAL nAngleX AS DOUBLE, BYVAL nAngleY AS DOUBLE, BYREF nA AS DOUBLE, BYREF nB AS DOUBLE)
DECLARE FUNCTION PDFDrawReportTemplate(BYREF sTemplateID AS DWSTRING) AS BOOLEAN

   Public:

      CRLF                       AS DWSTRING = CHR(13, 10)
      CR                         AS DWSTRING = CHR(13)
      LF                         AS DWSTRING = CHR(10)

      Declare Constructor
      Declare Destructor

      DECLARE SUB PDFViewerPreferences(BYVAL nThumbnails AS LONG, _
                                       BYVAL nHideMenuBar AS LONG, _
                                       BYVAL nHideToolBar AS LONG, _
                                       BYVAL nShowTitle AS LONG, _
                                       BYVAL nHideWindowUI AS LONG, _
                                       BYVAL nCenterWindow AS LONG, _
                                       BYVAL nFitWindow AS LONG)
       DECLARE SUB PDFCreateDocument()
       DECLARE FUNCTION PDFGetOutlineHeader(BYVAL sTitle AS DWSTRING) AS LONG
       DECLARE SUB PDFSetFontSize(BYVAL nFontSize AS LONG)
       DECLARE SUB PDFSetPageTextRenderingMode(BYVAL nRendering AS LONG)
       DECLARE SUB PDFSetPageWordSpacing(BYVAL nWordSpacing AS DOUBLE)
       DECLARE SUB PDFSetPageCharacterSpacing(BYVAL nCharacterSpacing AS DOUBLE)
       DECLARE SUB PDFSetPageHorizontalScaling(BYVAL nHorizontalScaling AS WORD)
       DECLARE SUB PDFSetPageTextLeading(BYVAL nTextLeading AS DOUBLE)
       DECLARE SUB PDFSetPaperSize(BYVAL nPaperID AS LONG)
       DECLARE FUNCTION PDFGetPaperSize() AS LONG
       DECLARE SUB PDFSetPaperOrientation(BYVAL nOrientation AS LONG)
       DECLARE FUNCTION PDFGetPaperOrientation() AS LONG
       DECLARE SUB PDFSetPaperTopMargin(BYVAL nMargin AS DOUBLE)
       DECLARE FUNCTION PDFGetPaperTopMargin() AS DOUBLE
       DECLARE SUB PDFSetPaperLeftMargin(BYVAL nMargin AS DOUBLE)
       DECLARE FUNCTION PDFGetPaperLeftMargin() AS DOUBLE
       DECLARE SUB PDFSetPaperBottomMargin(BYVAL nMargin AS DOUBLE)
       DECLARE FUNCTION PDFGetPaperBottomMargin() AS DOUBLE
       DECLARE SUB PDFSetPaperRightMargin(BYVAL nMargin AS DOUBLE)
       DECLARE FUNCTION PDFGetPaperRightMargin() AS DOUBLE
       DECLARE SUB PDFSetZoom (BYVAL nZoom AS LONG)
       DECLARE SUB PDFSetLayout (BYVAL nLayout AS LONG)
       DECLARE SUB PDFSetFontColor(BYVAL nRGB AS LONG)
       DECLARE SUB PDFSetProducer(BYVAL sPDFProducer AS DWSTRING)
       DECLARE SUB PDFSetAuthor(BYVAL sPDFAuthor AS DWSTRING)
       DECLARE SUB PDFSetCreator(BYVAL sPDFCreator AS DWSTRING)
       DECLARE SUB PDFSetSubject(BYVAL sPDFSubject AS DWSTRING)
       DECLARE SUB PDFSetTitle(BYVAL sPDFTitle AS DWSTRING)
       DECLARE SUB PDFSetKeywords(BYVAL sPDFKeywords AS DWSTRING)
       DECLARE FUNCTION PDFGetCurrentFontID() AS DWSTRING
       DECLARE FUNCTION PDFFont(BYVAL nFontFamily AS LONG, BYVAL nFontStyle AS LONG, BYVAL nReplaceDefaultFont AS CONST LONG = 0) AS DWSTRING
       DECLARE SUB PDFCurrentPageMetrics(BYREF uMetrics AS PageMetrics)
       DECLARE SUB PDFLineAdd (BYVAL nFromX AS DOUBLE, BYVAL nFromY AS DOUBLE, BYVAL nToX AS DOUBLE, _
                               BYVAL nToY AS DOUBLE, BYREF uLine AS LineDescriptor)
       DECLARE SUB PDFPlaceHolderLineCreate (BYVAL nFromX AS DOUBLE, BYVAL nFromY AS DOUBLE, BYVAL nToX AS DOUBLE, _
                                             BYVAL nToY AS DOUBLE, BYREF uLine AS LineDescriptor, BYVAL sPlaceHolderID AS DWSTRING)
       DECLARE SUB PDFPlaceHolderTextCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uText AS TextDescriptor, _
                                             BYVAL sPlaceHolderID AS DWSTRING, BYVAL sText AS DWSTRING)
       DECLARE SUB PDFPlaceHolderRectangleCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uRectangle AS RectangleDescriptor, _
                                                  BYVAL sPlaceHolderID AS DWSTRING)
       DECLARE SUB PDFPlaceHolderEllispeCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, _ 
                                                BYVAL nWidth AS DOUBLE, BYVAL nOutlineColor AS LONG, BYVAL nFillColor AS LONG, _
                                                BYVAL sPlaceHolderID AS DWSTRING)
       DECLARE SUB PDFPlaceHolderRegularPolygonCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, ByVal nRadius AS DOUBLE, _
                                                       BYVAL nSides AS LONG, BYVAL nFillColor AS LONG, BYREF uLine AS LineDescriptor, _
                                                       BYVAL sPlaceHolderID AS DWSTRING)
       DECLARE SUB PDFPlaceHolderWriteImageCreate (BYREF sImageID As DWSTRING, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                                   BYREF uImageOptions AS ImageOptions, BYVAL sPlaceHolderID AS DWSTRING)
       DECLARE SUB PDFPlaceHolderMultiLineCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uMultiLine As MultilineTextDescriptor, _
                                                  BYREF sString AS DWSTRING, BYVAL sPlaceHolderID AS DWSTRING)
       DECLARE SUB PDFInsertPlaceHolders()
       DECLARE SUB PDFRectangle(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uRectangle AS RectangleDescriptor)
       DECLARE FUNCTION PDFMultiLineTextBox (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                             BYREF uMultiLine As MultilineTextDescriptor, BYREF sString AS DWSTRING) AS LONG
       DECLARE SUB PDFDrawLine()
       DECLARE FUNCTION PDFMultiLineTextBoxMaximumLines (BYREF uMultiLine As MultilineTextDescriptor) AS LONG
       DECLARE SUB PDFWriteText(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                BYREF uTextDescriptor AS TextDescriptor, BYREF sText AS DWSTRING)
       DECLARE SUB PDFPageMetrics()
       DECLARE SUB PDFEndPage()
       DECLARE FUNCTION PDFEndDocument(BYREF sDocument AS DWSTRING, BYVAL nOpenPDF AS CONST LONG = 0) AS BOOLEAN
       DECLARE SUB PDFNewPage()
       DECLARE FUNCTION PDFMeasureString(BYREF sFontID AS DWSTRING, _
                                         BYREF sString AS DWSTRING, _
                                         BYVAL nFontSize AS LONG) AS DOUBLE
       DECLARE FUNCTION PDFLineHeight(BYREF sFontID AS DWSTRING, nFontSize AS LONG) AS DOUBLE
       DECLARE FUNCTION PDFWordCount(BYREF sString AS DWSTRING) AS LONG
       DECLARE FUNCTION AddImageJPEG(BYVAL sImageFile AS DWSTRING, BYREF sImageID AS DWSTRING) AS BOOLEAN
       DECLARE FUNCTION PDFWriteImage(BYREF sImageID As DWSTRING, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uImageOptions AS ImageOptions) AS BOOLEAN
       DECLARE SUB PDFEllispe(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, _
                              BYVAL nWidth AS DOUBLE, BYVAL nOutlineColor AS LONG, BYVAL nFillColor AS LONG)
       DECLARE SUB PDFRegularPolygon(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, ByVal nRadius AS DOUBLE, _
                                     BYVAL nSides AS LONG, BYVAL nFillColor AS LONG, BYREF uLine AS LineDescriptor)
       DECLARE FUNCTION PDFImageAttributes(BYREF sImageID AS DWSTRING, BYREF uImageAttributes AS ImageAttributes) AS BOOLEAN
       DECLARE FUNCTION PDFAddOutlineSection(BYVAL sName AS DWSTRING) AS BOOLEAN
       DECLARE FUNCTION PDFAddOutlineSubSection(BYVAL sName AS DWSTRING) AS BOOLEAN
       DECLARE FUNCTION PDFEmbedFont(BYVAL nFontFamily AS LONG, BYVAL nFontStyle AS LONG, BYVAL sFontFile AS DWSTRING) AS BOOLEAN
       DECLARE FUNCTION PDFCreateReportTemplate(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                                BYVAL nJustify AS LONG, BYREF uMargins AS RECT, uRectangle AS RectangleDescriptor) AS DWSTRING
       DECLARE FUNCTION PDFCreateReportHeaderTemplate(BYREF sTemplateID AS DWSTRING, BYREF uMargins AS RECT, uRectangle AS RectangleDescriptor) AS BOOLEAN
       DECLARE FUNCTION PDFCreateReportColumnHeaderTemplate(BYREF sTemplateID AS DWSTRING, BYREF uMargins AS RECT, uRectangle AS RectangleDescriptor) AS BOOLEAN
       DECLARE FUNCTION PDFAddReportColumns(BYREF sTemplateID AS DWSTRING, BYREF uMargins AS RECT, BYVAL sString AS DWSTRING, uRectangle AS RectangleDescriptor, _
                                       BYREF uText AS TextDescriptor, BYVAL nVerticalAlignment AS LONG, _
                                       BYVAL nOddLineFillColor AS LONG, BYVAL nEvenLineFillColor AS LONG) AS BOOLEAN
       DECLARE FUNCTION PDFDrawRows(BYREF sTemplateID AS DWSTRING, arRows() AS ReportRow) AS BOOLEAN
       DECLARE FUNCTION PDFAddHeaderText(BYREF sTemplateID AS DWSTRING, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                    BYREF uText AS TextDescriptor, BYVAL sHeaderText AS DWSTRING) AS BOOLEAN
       DECLARE FUNCTION CreateStringID(BYVAL sString AS DWSTRING) AS DWSTRING
       DECLARE FUNCTION GetLastErrorDescription() AS DWSTRING

End Type

Constructor cPDF

   CreateConsolasFont()
   CreateArialFont()
   CreateVerdanaFont()
   CreateTrebuchetFont()

   CreateCalibriFont()
   CreateTimesNewRomanFont()
   PaperTypes()
' Load zLib if it is provided

    hZlib = LoadLibrary("zlib1.dll")
    If hZlib <> 0 Then
        ZLibCompress = DyLibSymbol(hZlib, "compress")
        ZLibCompressBound = DyLibSymbol(hZlib, "compressBound")
        If ZLibCompress = 0 ORELSE ZLibCompressBound = 0 Then
           FreeLibrary hZlib
           hZlib = 0
        End If

    End If

End Constructor
 
Destructor cPDF

   If hZlib <> 0 Then
      FreeLibrary hZlib
   End If

   ERASE arCanvas
   ERASE arPlaceHolderObject
   ERASE arStringID
   ERASE arFontID
   ERASE arFontEmbed
   ERASE arFontWidths
   ERASE arImageID
   ERASE arImageStream
   ERASE arSection
   ERASE arSubSection
   ERASE arReportTemplate
   ERASE arReportHeaderTemplate
   ERASE arReportColumnHeaderTemplate
   ERASE arReportColumns
   ERASE arReportHeaderText
   oPageStreamList.Clear
   oObjectOffsetList.Clear
   oImageDescriptor.RemoveAll
   oImageStream.RemoveAll


End Destructor

Private Sub CPDF.PaperTypes()

DIM uPDFPaper    AS PDFPaper
DIM sPapers      AS DWSTRING
DIM nIndex       AS LONG = 1
DIM nStart       AS LONG
DIM sValue       AS DWSTRING
DIM dv           AS DVARIANT

' ISO Paper Sizes

   sPapers = ",A0,3370,2384,A1,2384,1684,A2,1684,1190,A3,1190,842,A4,842,595,A5,595,420" _
      + ",A6,420,298,A7,298,210,A8,210,148,B0,4008,2835,B1,2835,2004,B2,2004,1417" _
      + ",B3,1417,1001,B4,1001,709,B5,709,499,B6,499,354,B7,354,249,B8,249,176" _
      + ",B9,176,125,B10,125,88,"
      
   nStart = 1
   WHILE nStart < LEN(sPapers)
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.sPaperName = sValue
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperHeight = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperWidth = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      dv.PutBuffer(@uPDFPaper, SIZEOF(uPDFPaper))
      oPaperList.Add("P" + str(nIndex),dv)
      nIndex = nIndex + 1
   WEND
   
  ' C-sizes are used for envelopes to match the A-series paper. Unrealistic sizes like
  ' C0 (imagine an envelope measuring 917 by 1297 millimetres) have been omitted.
  
  sPapers = ",C2,578,1837,C3,919,578,C4,649,919,C5,459,649,C6,323,459,"
  
   nStart = 1
   WHILE nStart < LEN(sPapers)
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.sPaperName = sValue
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperHeight = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperWidth = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      dv.PutBuffer(@uPDFPaper, SIZEOF(uPDFPaper))
      oPaperList.Add("P" + str(nIndex),dv)
      nIndex = nIndex + 1
   WEND
   
  ' American paper sizes
  
  sPapers = ",Letter,792,612,Legal,1008,612,Ledger,1224,792,Tabloid,792,1224" _
     + ",Executive,756,522,ANSI C,1224,1584,ANSI D,1584,2448,ANSI E,2448,3168,"
     
   nStart = 1
   WHILE nStart < LEN(sPapers)
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.sPaperName = sValue
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperHeight = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperWidth = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      dv.PutBuffer(@uPDFPaper, SIZEOF(uPDFPaper))
      oPaperList.Add("P" + str(nIndex),dv)
      nIndex = nIndex + 1
   WEND
   
   ' English paper sizes
   
   sPapers = ",Foolscap,1188,954,Small Post,1332,1044,Sheet and 1/3 cap,1584,954,Sheet and 1/2 cap,1782,954,Demy,1440,1116" _
      + ",Large Post,1512,1188,Small medium,1584,1260,Medium,1656,1296,Small Royal,1728,1368,Royal,1800,1440,Imperial,2160,1584,"
      
   nStart = 1
   WHILE nStart < LEN(sPapers)
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.sPaperName = sValue
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperHeight = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperWidth = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      dv.PutBuffer(@uPDFPaper, SIZEOF(uPDFPaper))
      oPaperList.Add("P" + str(nIndex),dv)
      nIndex = nIndex + 1
   WEND
   
   ' UK metric book printing sizes
   
   sPapers = ",Metric Crown Quarto,697,536,Metric Crown Octavo,527,349,Metric Large Crown Quarto,731,570,Metric Large Crown Octavo,561,366" _
      + ",Metric Demy Quarto,782,621,Metric Demy Octavo,612,391,Metric Royal Quarto,884,672,Metric Royal Octavo,561,366,"
      
   nStart = 1
   WHILE nStart < LEN(sPapers)
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.sPaperName = sValue
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperHeight = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      sValue = AfxStrExtract(nStart,sPapers,",",",")
      uPDFPaper.nPaperWidth = VAL(sValue)
      nStart = nStart + LEN(sValue) + 1
      dv.PutBuffer(@uPDFPaper, SIZEOF(uPDFPaper))
      oPaperList.Add("P" + str(nIndex),dv)
      nIndex = nIndex + 1
   WEND

End Sub

' =====================================================================================
' Reset Fontlist so that only Consolas Normal is flagged for use
' =====================================================================================

Private SUB cPDF.PDFResetFonts()

DIM nIndex   AS LONG

    For nIndex = LBOUND(arFontID) to UBOUND(arFontID)

       If arFontID(nIndex).uFont.FontID = FONT_CONSOLAS ANDALSO arFontID(nIndex).uFont.FontStyle = PDF_FONT_NORMAL Then

          arFontID(nIndex).uFont.FontReferenced = 1
          sDefaultFontID = arFontID(nIndex).sFontID

       Else

          arFontID(nIndex).uFont.FontReferenced = 0

       End If

    Next

End Sub

Private SUB cPDF.PDFGetFontMetrics (BYREF sFontID AS DWSTRING, BYREF uDescriptor AS FontDescriptor)

DIM nIndex   AS LONG

   For nIndex = LBOUND(arFontID) to UBOUND(arFontID)

      If arFontID(nIndex).sFontID = sFontID Then
         uDescriptor = arFontID(nIndex).uFont
         EXIT FOR
      End If

   Next

End Sub

' =====================================================================================
' Use a GUID for PDF Document ID
' =====================================================================================

Private FUNCTION cPDF.PDFDocumentID() AS DWSTRING

DIM uGuid       AS GUID
DIM sGUID       AS DWSTRING

   uGUID = AfxGuid()
   sGUID = AfxGuidText(@uGUID)
   StringReplace(sGUID,"-","")
   StringReplace(sGUID,"{","")
   StringReplace(sGUID,"}","")

   RETURN sGUID

End Function

' =====================================================================================
' Calculate the height of one PDF line
' =====================================================================================

Private FUNCTION cPDF.PDFLineHeight(BYREF sFontID AS DWSTRING, nFontSize AS LONG) AS DOUBLE

DIM uFont       AS FontDescriptor

   PDFGetFontMetrics(sFontID,uFont)

   RETURN ((uFont.FontAscent * nFontSize) / 1000) _
             + (ABS(uFont.FontDescent) * nFontSize) / 1000

End Function

' =====================================================================================
' Count the number of words in a string
' =====================================================================================

Private FUNCTION cPDF.PDFWordCount(BYREF sString AS DWSTRING) AS LONG

DIM nWordCount   AS LONG = 0
DIM sWordLine    AS DWSTRING = AfxStrWrap(sString," ")
DIM nStart       AS LONG = 1
DIM sWordRaw     AS DWSTRING

   WHILE nStart < LEN(sWordLine) 

      sWordRaw = AfxStrExtractI(nStart,sWordLine," ")

      IF sWordRaw = "" THEN
         nStart = nStart + 1
         CONTINUE WHILE
      END IF

      nWordCount = nWordCount + 1
      nStart = nStart + LEN(sWordRaw) + 1

   WEND

   RETURN nWordCount

End Function

' =====================================================================================
' Calculate the length of a string
' =====================================================================================

Private FUNCTION cPDF.PDFMeasureString(BYREF sFontID AS DWSTRING, _
                                       BYREF sString AS DWSTRING, _
                                       BYVAL nFontSize AS LONG) AS DOUBLE
 
DIM arWidths()    AS LONG
DIM nTotalWidth   AS LONG = 0
DIM nStringLength AS LONG
DIM nIndex        AS LONG

    PDFFontWidths(sFontID, arWidths())

    nStringLength = LEN(sString)

    IF nStringLength > 0 THEN

      FOR nIndex = 1 To nStringLength

           nTotalWidth = nTotalWidth + arWidths(ASC(MID(sString,nIndex,1)))

      NEXT

    END IF

    RETURN (nTotalWidth * nFontSize) / 1000                                      

End Function

' =====================================================================================
' Get Font Widths
' =====================================================================================

Private SUB cPDF.PDFFontWidths(BYREF sFontID AS DWSTRING, arWidths() AS LONG)

DIM sWidthList      AS DWSTRING
DIM sWidth          AS DWSTRING
DIM nWidthStart     AS LONG = 1
DIM nWidthIndex     AS LONG
DIM nIndex          AS LONG

   ERASE arWidths
   For nIndex = LBOUND(arFontWidths) to UBOUND(arFontWidths)

      If arFontWidths(nIndex).sFontID = sFontID Then
         sWidthList = arFontWidths(nIndex).sFontWidths
         EXIT FOR
      End If

   Next

   WHILE nWidthStart < LEN(sWidthList)
      sWidth = AfxStrExtract(nWidthStart,sWidthList,",",",")
      AppendElementToArray (arWidths, CLNG(sWidth))
      nWidthStart = nWidthStart + LEN(sWidth) + 1
   WEND

End Sub

' =====================================================================================
'  Calculate the number of lines that will fit on a multi line text box
' =====================================================================================

Private FUNCTION cPDF.PDFMultiLineTextBoxMaximumLines (BYREF uMultiLine As MultilineTextDescriptor) AS LONG

DIM uFont       AS FontDescriptor
DIM nLineHeight AS DOUBLE

    nLineHeight = PDFLineHeight(uMultiLine.TextAttributes.FontID, uMultiLine.TextAttributes.FontSize)
    
' Now to calculate how many lines will fit

  RETURN INT(uMultiline.Height / ((uMultiLine.Spacing / 100) * nLineHeight))

End Function

' =====================================================================================
' Add an image of type JPEG
' =====================================================================================

Private FUNCTION cPDF.AddImageJPEG(BYVAL sImageFile AS DWSTRING, BYREF sImageID AS DWSTRING) AS BOOLEAN

DIM oCFileSys          AS CFileSys
DIM pGDIToken          AS ULONG_PTR
DIM nGPStatus          AS GpStatus
DIM szImageFile        As WSTRING * MAX_PATH
DIM pGDIImage          AS GPImage PTR
DIM ImageGUID          AS GUID
DIM GDIPixelFormat     AS PixelFormat
DIM uPDFImageID        AS PDFImageID
DIM nFileSize          AS LONG
DIM nTotalImages       AS LONG
DIM dwBytesRead        AS DWORD
DIM hFile              AS HANDLE
DIM dv                 AS DVARIANT
DIM sFileContents      AS STRING

    sLastErrorDescription = ""
    szImageFile = sImageFile

' Check if image file is valid

    If oCFileSys.FileExists(szImageFile) = False Then
       sLastErrorDescription = oCFileSys.GetErrorInfo()
       RETURN False
       EXIT FUNCTION

    End If

    uPDFImageID.uImage.ImageName = oCFileSys.GetFileName(szImageFile)

' Startup GDI+

    pGDIToken = AfxGdipInit()

'
' Load Image file
'
    nGPStatus = GdipLoadImageFromFile (@szImageFile, @pGDIImage)
    If nGPStatus <> S_OK Then
       sLastErrorDescription = szImageFile + " " + AfxGdipStatusStr(nGPStatus)
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION
    End If

' Check if image format if JPEG

    nGPStatus = GdipGetImageRawFormat(pGDIImage,@ImageGUID)
    If nGPStatus <> S_OK Then
       sLastErrorDescription = szImageFile + " " + AfxGdipStatusStr(nGPStatus)
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION
    End If

    If AfxGuidText(@ImageGUID) <> AfxGuidText(@ImageFormatJPEG) Then

       sLastErrorDescription = szImageFile + " is not a JPEG image file."
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION

    End If

' Check color depth

    nGPStatus = GdipGetImagePixelFormat (pGDIImage, @GDIPixelFormat)
    If nGPStatus <> S_OK Then
       sLastErrorDescription = szImageFile + " " + AfxGdipStatusStr(nGPStatus)
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION
    End If

    If GDIPixelFormat <> PixelFormat24bppRGB Then

       sLastErrorDescription = szImageFile + " JPEG color depth is not supported."
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION

    End If

    nGPStatus = GdipGetImageHorizontalResolution (pGDIImage, @uPDFImageID.uImage.HorizontalResolution)
    If nGPStatus <> S_OK Then
       sLastErrorDescription = szImageFile + " " + AfxGdipStatusStr(nGPStatus)
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION
    End If

    nGPStatus = GdipGetImageVerticalResolution (pGDIImage, @uPDFImageID.uImage.VerticalResolution)
    If nGPStatus <> S_OK Then
       sLastErrorDescription = szImageFile + " " + AfxGdipStatusStr(nGPStatus)
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION
    End If

    nGPStatus = GdipGetImageWidth(pGDIImage, @uPDFImageID.uImage.ImagePixelWidth)
    If nGPStatus <> S_OK Then
       sLastErrorDescription = szImageFile + " " + AfxGdipStatusStr(nGPStatus)
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION
    End If

    nGPStatus = GdipGetImageHeight(pGDIImage, @uPDFImageID.uImage.ImagePixelHeight)
    If nGPStatus <> S_OK Then
       sLastErrorDescription = szImageFile + " " + AfxGdipStatusStr(nGPStatus)
       GdipDisposeImage pGDIImage
       AfxGdipShutdown pGDIToken
       RETURN False
       EXIT FUNCTION
    End If

' Shutdown GDI+

    GdipDisposeImage pGDIImage
    AfxGdipShutdown pGDIToken

' Convert to PDF measurement 1/72's inch

    uPDFImageID.uImage.ImageWidth = uPDFImageID.uImage.ImagePixelWidth * PDF_MEASUREMENT / uPDFImageID.uImage.HorizontalResolution
    uPDFImageID.uImage.ImageHeight = uPDFImageID.uImage.ImagePixelHeight * PDF_MEASUREMENT / uPDFImageID.uImage.VerticalResolution

' Get File Size

    uPDFImageID.uImage.ImageSize = oCFileSys.GetFileSize(szImageFile)

' Get Raw Stream

   sFileContents = SPACE(uPDFImageID.uImage.ImageSize)
   hFile = CreateFileW(@szImageFile, GENERIC_READ, FILE_SHARE_READ, NULL, _
                       OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL)
   ReadFile(hFile, STRPTR(sFileContents), uPDFImageID.uImage.ImageSize, @dwBytesRead, NULL)
   CloseHandle(hFile)

' Save Image for reference

   nTotalImages = UBOUND(arImageID) + 1
   sImageID = "I" + FORMAT(nTotalImages)
   uPDFImageID.sImageID = sImageID
   uPDFImageID.uImage.ImageReferenced = False
   AppendElementToArray(arImageID,uPDFImageID)
   AppendElementToArray(arImageStream,sFileContents)

   RETURN True

End Function

Private SUB cPDF.SkewMatrix (BYVAL nAngleX AS DOUBLE, BYVAL nAngleY AS DOUBLE, BYREF nA AS DOUBLE, BYREF nB AS DOUBLE)

    nAngleX = (nAngleX * -1) * PI / 180
    nAngleY = (nAngleY * -1) * PI / 180       ' Convert to radians

    nA = TAN(nAngleX)
    nB = TAN(nAngleY)

End Sub

' =====================================================================================
' Draw a previously defined image
' =====================================================================================

Private FUNCTION cPDF.PDFWriteImage(BYREF sImageID As DWSTRING, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uImageOptions AS ImageOptions) AS BOOLEAN

DIM uCanvas           AS PageCanvas
DIM nIndex            AS LONG
DIM nA                AS DOUBLE
DIM nB                AS DOUBLE
DIM nC                AS DOUBLE
DIM nD                AS DOUBLE
DIM nScalingPercent   AS DOUBLE
DIM nRotationAngle    AS DOUBLE
DIM nXSkewAngle       AS DOUBLE
DIM nYSkewAngle       AS DOUBLE
DIM bReturn           AS BOOLEAN = False

   sLastErrorDescription = ""

' In order to have predictable and repeatable results, the order of drawing the image is:

' 1. Translate
' 2. Rotate
' 3. Scale
' 4. Skew

   If UBOUND(arImageID) >= 0 Then

      For nIndex = LBOUND(arImageID) to UBOUND(arImageID)

         If arImageID(nIndex).sImageID = sImageID Then
  
            arImageID(nIndex).uImage.ImageReferenced = True
            bReturn = True
            GetCurrentCanvas(uCanvas)
            DrawingPoints(uCanvas,nX,nY)
            SaveGraphicsState()

' Translate

            BuildObject(sTempStream,"1 0 0 1 " + _
                        FormatPoint(nX) + " " + _
                        FormatPoint(nY) + " cm")

' Rotate

           If uImageOptions.RotationAngle = ITEM_IGNORE Then
              nRotationAngle = 0
           End If

           If nRotationAngle <> 0 Then
              RotationMatrix(nRotationAngle,nA,nB,nC,nD)
              BuildObject(sTempStream,FormatPoint(nA) + " " + _
                          FormatPoint(nB) + " " + _
                          FormatPoint(nC) + " " + _
                          FormatPoint(nD) + " 0 0 cm")
           End If

' Image Scaling Percentage

           If uImageOptions.ScalingPercent = ITEM_IGNORE ORELSE uImageOptions.ScalingPercent = 0 Then
              nScalingPercent = 1.00
           Else
              nScalingPercent = ABS(uImageOptions.ScalingPercent)
           End If

           BuildObject(sTempStream,FormatPoint(arImageID(nIndex).uImage.ImageWidth * nScalingPercent) + " 0 0 " + _
                       FormatPoint(arImageID(nIndex).uImage.ImageHeight * nScalingPercent) + " 0 0 cm")

' Skew

           If uImageOptions.XSkewAngle = ITEM_IGNORE Then
              nXSkewAngle = 0
           Else
              nXSkewAngle = uImageOptions.XSkewAngle
           End If

           If uImageOptions.YSkewAngle = ITEM_IGNORE Then
              nYSkewAngle = 0
           Else
              nYSkewAngle = uImageOptions.YSkewAngle
           End If

           If nXSkewAngle + nYSkewAngle <> 0 Then

              SkewMatrix(nXSkewAngle,nYSkewAngle,nA,nB)
              BuildObject(sTempStream,"1 " + _
                          FormatPoint(nA) + " " + _
                          FormatPoint(nB) + " 1 0 0 cm")

           End If

           BuildObject(sTempStream,"/" + sImageID + " Do")
           RestoreGraphicsState()
  
           EXIT FOR

        End If

     Next

   End If

   If bReturn = False Then

      sLastErrorDescription = "Image ID " + sImageID + " not found."

   End If

   RETURN bReturn

End Function


' =====================================================================================
' Determine if there is room remaining in sLine for sWord to fit.
' A space is optionally prepended to the word before the calculation, and
' if the word will fit, it is added to sLine
'
' Return is 1 if word fits, 0 if it does not
' =====================================================================================

Private FUNCTION cPDF.PDFMultiLineInsertWord(BYREF sFontID AS DWSTRING, _
                                             BYVAL nFontSize AS LONG, _
                                             BYVAL nWidth AS LONG, _
                                             BYVAL sWord AS DWSTRING, _
                                             BYREF sLine AS DWSTRING) AS LONG

DIM nReturn        As Long
DIM nWordSize      As Double
DIM nLineSize      As Double

    nReturn = 0

    nLineSize = PDFMeasureString(sFontID,sLine,nFontSize)

    If nLineSize + nWordSize <= nWidth Then

       If Len(sLine) = 0 Then

          sLine = sWord

       Else

        sLine = sLine + sWord

       End If

       nReturn = 1

    End If

    Return nReturn

End Function

' =====================================================================================
' Add single line of new content to the object stream
' =====================================================================================

Private SUB cPDF.BuildObject(BYREF sObject as STRING, BYVAL sObjectPart AS STRING)

DIM sCRLF       AS STRING = CRLF
DIM nObjectSize AS LONG = LEN(sObjectPart)
DIM sNewObject  AS STRING

   If nObjectSize > 0 Then

      sNewObject = SPACE(LEN(sObject) + nObjectSize + LEN(sCRLF))

      If LEN(sObject) > 0 Then
         memcpy(STRPTR(sNewObject), STRPTR(sObject), LEN(sObject))
         memcpy(STRPTR(sNewObject) + LEN(sObject), STRPTR(sObjectPart), LEN(sObjectPart))
      Else
         memcpy(STRPTR(sNewObject), STRPTR(sObjectPart), LEN(sObjectPart))
      End If

      memcpy(STRPTR(sNewObject) + LEN(sNewObject) - LEN(sCRLF), STRPTR(sCRLF), LEN(sCRLF))

   End If

   sObject = sNewObject

End Sub

Private SUB cPDF.PDFNewSubPath(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE)

DIM uCanvas    AS PageCanvas

    GetCurrentCanvas(uCanvas)
    DrawingPoints(uCanvas,nX,nY)

    BuildObject(sTempStream,FormatPoint(nX) + " " + FormatPoint(nY) + " m")

End Sub

Private SUB cPDF.PDFMoveTo(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE)

DIM uCanvas    AS PageCanvas

    GetCurrentCanvas(uCanvas)

    DrawingPoints(uCanvas,nX,nY)

    BuildObject(sTempStream,TRIM(FORMAT(nX,"#####.0####")) + " " + TRIM(FORMAT(nY,"#####.0####")) + " l")

End Sub

' =====================================================================================
' Draw a curved bezier arc from the current point
' =====================================================================================

Private SUB cPDF.PDFCurve(BYVAL nX1Control AS DOUBLE, BYVAL nY1Control AS DOUBLE, BYVAL nX2Control AS DOUBLE, _
                          BYVAL nY2Control AS DOUBLE, BYVAL nXEnd AS DOUBLE, BYVAL nYEnd AS DOUBLE)

DIM uCanvas   AS PageCanvas

    GetCurrentCanvas(uCanvas)

    DrawingPoints(uCanvas,nX1Control,nY1Control)
    DrawingPoints(uCanvas,nX2Control,nY2Control)
    DrawingPoints(uCanvas,nXEnd,nYEnd)

    BuildObject(sTempStream,FormatPoint(nX1Control) + " " + _
                            FormatPoint(nY1Control) + " " + _
                            FormatPoint(nX2Control) + " " + _
                            FormatPoint(nY2Control) + " " + _
                            FormatPoint(nXEnd) + " " + _
                            FormatPoint(nYEnd) + " c")

End Sub

Private SUB cPDF.PDFSquareRectangle(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, _
                                    BYVAL nWidth AS DOUBLE, BYVAL nFillColor AS LONG, BYREF uLine As LineDescriptor)

DIM uCanvas   AS PageCanvas

    GetCurrentCanvas(uCanvas)
    SaveGraphicsState()

    PDFLineAttributes(uLine)

    nY = nY + nHeight
    DrawingPoints(uCanvas,nX,nY)

    BuildObject(sTempStream, _
                TRIM(Format(nX,"#####.0####")) + " " + TRIM(Format(nY,"#####.0####")) + " " + _
                TRIM(Format(nWidth,"#####.0####")) + " " + TRIM(Format(nHeight,"#####.0####")) + " re")

    If nFillColor <> ITEM_IGNORE Then

       SetNonStrokingColor(nFillColor)
       PDFPathFillAndStroke(1)

    Else

       PDFPathStroke(1)

    End If

    RestoreGraphicsState()

End Sub

Private SUB cPDF.PDFRoundedRectangle(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, BYVAL nWidth AS DOUBLE, _
                                     BYVAL nFillColor As Long, BYREF uLine As LineDescriptor, _
                                     BYVAL nRadius AS DOUBLE, BYREF uCorners AS RECT)

' Draw a rectangle with optional rounded corners
' uCorners RECT structure is treated as flags to decide if a corner will be rounded

' Upper Left = uCorners.Top
' Upper Right = uCorners.Right
' Lower Right = uCorners.Bottom
' Lower Left = uCorners.Left

DIM nCenterX          AS DOUBLE
DIM nCenterY          AS DOUBLE

    PDFStartLine(nX + nRadius,nY,uLine)

    nCenterX = nX + nWidth - nRadius
    nCenterY = nY + nRadius

    PDFMoveTo(nCenterX,nY)

' Check if top right corner is to be rounded

    If uCorners.Right = ITEM_IGNORE Then

       PDFMoveTo(nX + nWidth,nY)

    Else

        PDFCurve(nCenterX + nRadius * nBezierMagic, _
                 nCenterY - nRadius, _
                 nCenterX + nRadius, _
                 nCenterY - nRadius * nBezierMagic, _
                 nCenterX + nRadius, _
                 nCenterY)

    End If

    nCenterX = nX + nWidth - nRadius
    nCenterY = nY + nHeight - nRadius

    PDFMoveTo(nX + nWidth,nCenterY)

' Check if bottom right corner is to be rounded

    If uCorners.Bottom = ITEM_IGNORE Then

       PDFMoveTo(nX + nWidth,nY + nHeight)

    Else

        PDFCurve(nCenterX + nRadius, _
                 nCenterY + nRadius * nBezierMagic, _
                 nCenterX + nRadius * nBezierMagic, _
                 nCenterY + nRadius, _
                 nCenterX, _
                 nCenterY + nRadius)

    End If

    nCenterX = nX + nRadius
    nCenterY = nY + nHeight - nRadius

    PDFMoveTo(nCenterX,nCenterY + nRadius)

' Check if bottom right corner is to be rounded

    If uCorners.Left = ITEM_IGNORE Then

       PDFMoveTo(nX,nY + nHeight)

    Else

        PDFCurve(nCenterX - nRadius * nBezierMagic, _
                 nCenterY + nRadius, _
                 nCenterX - nRadius, _
                 nCenterY + nRadius * nBezierMagic, _
                 nCenterX - nRadius, _
                 nCenterY)

    End If

    nCenterX = nX + nRadius
    nCenterY = nY + nRadius

    PDFMoveTo(nX,nCenterY)

' Check if bottom right corner is to be rounded

    If uCorners.Top = ITEM_IGNORE Then

       PDFMoveTo(nX,nY)
       PDFMoveTo(nX + nRadius,nY)

    Else

        PDFCurve(nCenterX - nRadius, _
                 nCenterY - nRadius * nBezierMagic, _
                 nCenterX - nRadius * nBezierMagic, _
                 nCenterY - nRadius, _
                 nCenterX, _
                 nCenterY - nRadius)

    End If

    If nFillColor <> ITEM_IGNORE Then

        SetNonStrokingColor(nFillColor)
        PDFPathFillAndStroke(1)

    Else

        PDFDrawLine()

    End If

    RestoreGraphicsState()

End Sub

' =====================================================================================
' Adjust x,y for page margins and top down placement
' =====================================================================================

Private SUB cPDF.DrawingPoints(BYREF uCanvas As PageCanvas, BYREF nX AS DOUBLE, BYREF nY AS DOUBLE)

    nX = nX + uCanvas.LeftMargin
    nY = uCanvas.Height - nY - uCanvas.TopMargin

End Sub

' =====================================================================================
' Save current graphics state
' =====================================================================================

Private SUB cPDF.SaveGraphicsState()

   BuildObject(sTempStream,"q")

End Sub

' =====================================================================================
' Define the start of a line path
' =====================================================================================

Private SUB cPDF.PDFStartLine(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uLine As LineDescriptor)

    SaveGraphicsState()
    PDFLineAttributes(uLine)
    PDFNewSubPath(nX,nY)

End Sub

' =====================================================================================
' Restore graphics state
' =====================================================================================

Private SUB cPDF.RestoreGraphicsState()

   BuildObject(sTempStream,"Q")

End Sub

Private SUB cPDF.PDFPathStroke(BYVAL nClosePath AS CONST LONG = 0)

   BuildObject(sTempStream,IIF(nClosePath <> 0,"s","S"))

End Sub

Private SUB cPDF.PDFPathFillAndStroke(BYVAL nClosePath AS CONST LONG = 0)

   BuildObject(sTempStream,IIF(nClosePath <> 0,"b","B"))

End Sub

Private SUB cPDF.PDFLineJoin(BYVAL nLineJoin AS LONG)

    If nLineJoin >= PDF_LINEJOIN_MITER AndAlso nLineJoin <= PDF_LINEJOIN_BEVEL Then

       BuildObject(sTempStream,str(nLineJoin) + " j")

    End If

End Sub

Private SUB cPDF.PDFLineCap(BYVAL nLineJoin AS LONG)

    If nLineJoin >= PDF_LINECAP_BUTT AndAlso nLineJoin <= PDF_LINECAP_PROJECTING_SQUARE Then

       BuildObject(sTempStream,str(nLineJoin) + " J")

    End If

End Sub

Private SUB cPDF.PDFLineWidth(BYVAL nWidth AS DOUBLE)

   BuildObject(sTempStream,TRIM(FORMAT(nWidth,"###.0####")) + " w")

End Sub

Private SUB cPDF.PDFDrawLine()

    BuildObject(sTempStream,"S")

End Sub

Private SUB cPDF.StringReplace(BYREF sText As DWSTRING, BYVAL sMatch AS DWSTRING, BYVAL sReplace AS DWSTRING)

    sText = AfxStrReplaceI(sText, sMatch, sReplace)

End Sub

Private FUNCTION cPDF.FormatPoint(BYVAL nPoint AS DOUBLE) AS DWSTRING

DIM sPoint    AS DWSTRING

    sPoint = TRIM(Format(nPoint + .000005,"#####0.0####"))

    StringReplace(sPoint,".00000","")

    RETURN sPoint

End Function

Private SUB cPDF.PDFLineDash(BYREF uDash AS LineDash)

    If TRIM(uDash.Array1) <> "" Then

       BuildObject(sTempStream,"[" + TRIM(uDash.Array1) + "] " + FormatPoint(uDash.Phase) + " d")

    End If

End Sub

Private SUB cPDF.PDFLineMiter(BYREF nMiter AS DOUBLE)

    BuildObject(sTempStream,FormatPoint(nMiter) + " M")

End Sub

Private SUB cPDF.SetStrokingColor(ByVAL nColor AS LONG)

    If nColor >= 0 Then

        BuildObject(sTempStream,RGB2PDFColor(nColor) + " RG")

    End If

End Sub

Private SUB cPDF.SetNonStrokingColor(ByVAL nColor AS LONG)

    If nColor >= 0 Then

        BuildObject(sTempStream,RGB2PDFColor(nColor) + " rg")

    End If

End Sub

Private FUNCTION cPDF.RGB2PDFColor(BYVAL nRGB AS LONG) AS DWSTRING

DIM pRGB      AS UBYTE POINTER = CAST(UBYTE POINTER, @nRGB)
DIM nRed      AS LONG
DIM nGreen    AS LONG
DIM nBlue     AS LONG

    nRed = CAST(LONG,pRGB[0])
    nGreen = CAST(LONG,pRGB[1])
    nBlue = CAST(LONG,pRGB[2])

    RETURN TRIM(FORMAT((nRed / 255) + .000005,"0.0000#")) _
           + " " _
           + TRIM(FORMAT((nGreen / 255) + .000005,"0.0000#")) _
           + " " _
           + TRIM(FORMAT((nBlue / 255) + .000005,"0.0000#"))

End Function

' =====================================================================================
'  Set line attributes - active during next stroking operation
' =====================================================================================

Private SUB cPDF.PDFLineAttributes(BYREF uLine AS LineDescriptor)

    If uLine.Color <> ITEM_IGNORE Then

       SetStrokingColor(uLine.Color)

    End If

    If uLine.Width > 0 Then

       PDFLineWidth(uLine.Width)

    End If

    If uLine.Cap <> ITEM_IGNORE Then

       PDFLineCap(uLine.Cap)

    End If

    If uLine.Join <> ITEM_IGNORE Then

       PDFLineJoin(uLine.Join)

    End If

    PDFLineDash(uLine.dash)

    If uLine.Miter <> ITEM_IGNORE Then

       PDFLineMiter(uLine.Miter)

    End If

End Sub

' =====================================================================================
' Multiline Text Box
' =====================================================================================

Private FUNCTION cPDF.PDFMultiLineTextBox (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                           BYREF uMultiLine As MultilineTextDescriptor, BYREF sString AS DWSTRING) AS LONG

' Overflow is returned in sString when return is 0

DIM sWord           AS DWSTRING
DIM sWordRaw        AS DWSTRING
DIM sRawString      AS DWSTRING
DIM nStart          AS LONG
DIM nIndex          AS LONG
DIM nWordIndex      AS LONG
DIM arRawLines()    AS DWSTRING
DIM arLines()       AS DWSTRING
DIM sLine           AS DWSTRING
DIM sWordLine       AS DWSTRING
DIM nMaxLines       AS LONG
DIM nTotalHeight    AS DOUBLE
DIM nLineHeight     AS DOUBLE
DIM uFont           AS FontDescriptor

    If Len(sString) = 0 Then
       RETURN 1
       EXIT FUNCTION
    End If

' Get the font metrics for the ascent and descent values
' Together with the font size this defines the height of one line

    nLineHeight = PDFLineHeight(uMultiLine.TextAttributes.FontID, uMultiLine.TextAttributes.FontSize)

' Check that spacing is at least 100%

    If uMultiLine.Spacing < 100 Then

       uMultiLine.Spacing = PDF_SPACING_SINGLE

    End If

' Take the string and replace "hard line breaks" with a single carriage return

    sRawString = sString
    StringReplace(sRawString,CRLF,CR)
    StringReplace(sRawString,LF,CR)

' sRawString has to end with a CR

    If MID(sRawString, LEN(sRawString), 1) <> CR Then
        sRawString = sRawString + CR
    End If

' Parse out the lines to arRawLines

   nStart = 1
   WHILE nStart < LEN(sRawString)
      sLine = AfxStrExtractI(nStart,sRawString,CR)
      AppendElementToArray(arRawLines, sLine)
      nStart = nStart + LEN(sLine) + 1
   WEND

' Take each line and isolate the words to see how many will fit on one line

   sWordLine = ""

   FOR nIndex = LBOUND(arRawLines) TO UBOUND(arRawLines)

      sLine = AfxStrWrap(arRawLines(nIndex)," ")
      nStart = 1
      sWord = ""
      WHILE nStart < LEN(sLine)

' Skip over added starting space

         sWordRaw = AfxStrExtractI(nStart,sLine," ")

         IF sWordRaw = "" ANDALSO nStart = 1 THEN
            nStart = nStart + 1
            CONTINUE WHILE
         END IF

' Add space back in

         IF sWordRaw = "" THEN
            sWord = sWord + " "    
            nStart = nStart + 1
            CONTINUE WHILE
         END IF

' Build up word found

         sWord = sWordRaw + " "
         nStart = nStart + LEN(sWordRaw) + 1

         IF PDFMultiLineInsertWord(uMultiLine.TextAttributes.FontID, _
                                   uMultiLine.TextAttributes.FontSize, _
                                   uMultiLine.Width, _
                                   sWord, _
                                   sWordLine) = 0 THEN

' Word doesn't fit, move it to the next line

            AppendElementToArray(arLines, sWordLine)
            sWordLine = sWord

         END IF

      WEND

      IF sWordLine <> "" THEN

         IF MID(sWordLine,LEN(sWordLine),1) = " " THEN
            sWordLine = LEFT(sWordLine,LEN(sWordLine) - 1)
         END IF

      END IF

      IF sWordLine <> "" THEN
      
         AppendElementToArray(arLines,sWordLine)

      END IF

      sWordLine = ""

   NEXT

   nMaxLines = PDFMultiLineTextBoxMaximumLines(uMultiLine)

' Check if we have sufficient height for at least one line

    If nMaxLines = 0 Then

       RETURN 0
       EXIT FUNCTION

    End If

' If the number of lines that will fit is less than the total presented,
' return the portion that did not fit

    If nMaxLines < UBOUND(arLines) + 1 Then

       sString = ""

       For nIndex = nMaxLines To UBOUND(arLines) + 1

           sString = sString + arLines(nIndex - 1) + IIF(nIndex <> nMaxLines," ","")

       Next nIndex

       RETURN 0
       EXIT FUNCTION

    End If

' Adjust nX for Center or Right justifications

    If uMultiLine.TextAttributes.Justify = TEXT_JUSTIFY_RIGHT Then

       nX = nx + uMultiLine.Width - 1

    Else

       If uMultiLine.TextAttributes.Justify = TEXT_JUSTIFY_CENTER Then

          nx = nx + (uMultiLine.Width / 2) - 1

       End If

    End If 

' Adjust nY for vertical alignment

    nTotalHeight = nLineHeight + UBOUND(arLines) * ((uMultiLine.Spacing / 100) * nLineHeight)

    If uMultiline.VerticalAlignment = TEXT_VERTICAL_CENTER Then

            nY = nY _
               + ((uMultiline.Height - nTotalHeight) / 2) _
               - (((Abs(uFont.FontDescent) * uMultiLine.TextAttributes.FontSize) / 1000) * UBOUND(arLines)) _
               + Abs(uFont.FontDescent) * (uMultiLine.TextAttributes.FontSize / 1000)

    Else

' Adjust nY for bottom alignment

       If uMultiline.VerticalAlignment = TEXT_VERTICAL_BOTTOM Then

          nY = nY _
             + uMultiline.Height _
             - nTotalHeight _
             - (((Abs(uFont.FontDescent) * uMultiLine.TextAttributes.FontSize) / 1000) * UBOUND(arLines))

       End If

    End If

' Output each line

    For nIndex = LBOUND(arLines) To UBOUND(arLines)

        If nIndex > 0 Then

          nY = nY + ((uMultiLine.Spacing / 100) * nLineHeight)

        End If

        PDFWriteText(nX,nY,uMultiLine.TextAttributes,arLines(nIndex))

   Next

   RETURN 1

End Function

' =====================================================================================
' Prepare for a new PDF document
' =====================================================================================

Private SUB cPDF.PDFCreateDocument()

DIM nIndex        AS LONG
DIM uDescriptor   AS FontDescriptor
DIM dv            AS DVARIANT
DIM sFontID       AS DWSTRING
DIM uCanvas       AS PageCanvas
DIM nBias         AS LONG
DIM sContent      AS STRING
DIM sTime         AS DWSTRING
DIM sSign         AS DWSTRING
DIM uSystemTime   AS SYSTEMTIME = AfxSystemSystemTime()
DIM uLocalTime    AS SYSTEMTIME = AfxLocalSystemTime()
DIM nSystemTime   AS DOUBLE = AfxSystemTimeToVariantTime(uLocalTime)
DIM nLocalTime    AS DOUBLE = AfxSystemTimeToVariantTime(uSystemTime)
DIM nTimeDiff     AS DOUBLE
DIM uTimeDiff     AS SYSTEMTIME
DIM uMetrics      AS PageMetrics

    PDFResetFonts()

' Setup Page Metrics

    PDFCurrentPageMetrics(uMetrics)

    uCanvas.ObjectNumber = 0
    uCanvas.StreamObject = 0
    uCanvas.StreamComplete = False
    uCanvas.Width = uMetrics.Width
    uCanvas.Height = uMetrics.Height
    uCanvas.LeftMargin = uMetrics.LeftMargin
    uCanvas.TopMargin = uMetrics.TopMargin
    uCanvas.RightMargin = uMetrics.RightMargin
    uCanvas.BottomMargin = uMetrics.BottomMargin
    uCanvas.DrawingHeight = uMetrics.DrawingHeight
    uCanvas.DrawingWidth = uMetrics.DrawingWidth
    uCanvas.Orientation = uMetrics.Orientation

    CreateCanvas(uCanvas)
    sTempStream = ""

' PDF Header

    sPDFStream = "%PDF-1.7" + CRLF + CHR(128) + CHR(129) + CHR(130) + CHR(131) + CRLF

    SaveOffset(LEN(sPDFStream))

' PDF Documentation Information

    nTimeDiff = nSystemTime - nLocalTime
    uTimeDiff = AfxVariantTimeToSystemTime(nTimeDiff)

    If uTimeDiff.wHour = 0 Then
       sSign = "Z"
    Else
       If nTimeDiff > 0 Then
          sSign = "+"
       Else
          sSign = "-"
       End If
    End If

    sTime = FORMAT(uLocalTime.wYear,"0000") _
          + FORMAT(uLocalTime.wMonth,"00") _
          + FORMAT(uLocalTime.wDay,"00") _
          + FORMAT(uLocalTime.wHour,"00") _
          + FORMAT(uLocalTime.wMinute,"00") _
          + FORMAT(uLocalTime.wSecond,"00") _
          + sSign _
          + FORMAT(uTimeDiff.wHour,"00") _
          + "'" _
          + FORMAT(uTimeDiff.wMinute,"00") _
          + "'"

    nCurrentObjectNumber = 1
    sContent = ""

    BuildObject(sContent,"1 0 obj")
    BuildObject(sContent,"<<")
    BuildObject(sContent,"/Producer (" + sProducer + ")")
    BuildObject(sContent,"/Author (" + sAuthor + ")")
    BuildObject(sContent,"/CreationDate (D:" + sTime + ")")
    BuildObject(sContent,"/Creator (" + sCreator + ")")
    BuildObject(sContent,"/Keywords (" + sKeywords + ")")
    BuildObject(sContent,"/Subject (" + sSubject + ")")
    BuildObject(sContent,"/Title (" + sTitle + ")")
    BuildObject(sContent,"/ModDate (D:" + sTime + ")")
    BuildObject(sContent,">>")
    BuildObject(sContent,"endobj")

    SaveOffset(Len(sContent))
    sPDFStream = sPDFStream + sContent

' Start a stream object for the first page

    StartStream()

End Sub

' =====================================================================================
' Get Font ID and optionally set Font ID to current
' =====================================================================================

Private FUNCTION cPDF.PDFFont(BYVAL nFontFamily AS LONG, BYVAL nFontStyle AS LONG, BYVAL nReplaceDefaultFont AS CONST LONG = 0) AS DWSTRING

DIM nIndex            AS Long
DIM sFontID           AS DWSTRING = ""

    For nIndex = LBOUND(arFontID) to UBOUND(arFontID)

       If arFontID(nIndex).uFont.FontID = nFontFamily ANDALSO arFontID(nIndex).uFont.FontStyle = nFontStyle Then

             arFontID(nIndex).uFont.FontReferenced = 1
             sFontID = arFontID(nIndex).sFontID

             If nReplaceDefaultFont <> 0 Then
                sDefaultFontID = sFontID
             End If

             EXIT FOR

       End If

    Next      

    RETURN sFontID

End Function

' =====================================================================================
' Center a string on point nPoint and return the canvas page point
' =====================================================================================

Private FUNCTION cPDF.PDFCenterString(BYREF sString AS DWSTRING, BYVAL nPoint AS DOUBLE, _
                                      BYREF sFontID AS DWSTRING, BYVAL nFontSize AS LONG) AS DOUBLE

DIM nStringSize   AS DOUBLE

    nStringSize = PDFMeasureString(sFontID,sString,nFontSize)

    RETURN nPoint - (nStringSize / 2)

End Function

' =====================================================================================
' Start a text stream
' =====================================================================================

Private SUB cPDF.PDFBeginText()

    SaveGraphicsState()
    BuildObject(sTempStream,"BT")

End Sub

' =====================================================================================
' End a text stream
' =====================================================================================

Private SUB cPDF.PDFEndText()

    BuildObject(sTempStream,"ET")
    RestoreGraphicsState()

End Sub

Private SUB cPDF.PDFTextNewLine()

    BuildObject(sTempStream,"T*")

End Sub

' =====================================================================================
' Add text to current stream
' =====================================================================================

Private SUB cPDF.PDFAddText(BYREF sText AS DWSTRING, BYVAL nX AS LONG, BYVAL nNewLine AS CONST LONG = -1)

DIM sEscapedText      AS DWSTRING

' Escape PDF special characters

    sEscapedText = sText
    StringReplace(sEscapedText,"\","\\")
    StringReplace(sEscapedText,"\\","\\\\")
    StringReplace(sEscapedText,"(","\(")
    StringReplace(sEscapedText,")","\)")

    If nX <> 0 Then

        PDFTextMoveTo(nX,0)

    End If

    PDFShowText(sEscapedText)

    If nNewLine = TEXT_NEXT_LINE Then

        PDFTextNewLine()

    End If

End Sub

' =====================================================================================
' Add text object to page stream
' =====================================================================================

Private SUB cPDF.PDFWriteText(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                              BYREF uTextDescriptor AS TextDescriptor, BYREF sText AS DWSTRING)

DIM uCanvas           AS PageCanvas
DIM nTextX            AS DOUBLE
DIM nTextY            AS DOUBLE
DIM nTextSize         AS DOUBLE
DIM nLineThickness    AS DOUBLE
DIM nLineX            AS DOUBLE
DIM uDescriptor       AS FontDescriptor
DIM sFontID           AS DWSTRING
DIM nFontSize         AS LONG
DIM nFontColor        AS LONG

    sFontID = IIF(LEN(TRIM(uTextDescriptor.FontID)) = 0,sDefaultFontID,TRIM(uTextDescriptor.FontID))
    nFontSize = IIF(uTextDescriptor.FontSize = ITEM_IGNORE,nDefaultFontSize,uTextDescriptor.FontSize)
    nFontColor = IIF(uTextDescriptor.FontColor = ITEM_IGNORE,nDefaultFontColor,uTextDescriptor.FontColor)
    nTextSize = PDFMeasureString(sFontID,sText,nFontSize)
    nLineX = nX
    GetCurrentCanvas(uCanvas)
    PDFGetFontMetrics(sFontID,uDescriptor)
    PDFBeginText()

' Justify Center, nX is the center point sText
' Justify Right, nX is the end point for sText

    If uTextDescriptor.Justify = TEXT_JUSTIFY_CENTER Then

       nx = PDFCenterString(sText,nX,sFontID,nFontSize)

    Else

       If uTextDescriptor.Justify = TEXT_JUSTIFY_RIGHT Then

          nX = nX - nTextSize

       End If

    End If

' Save in case we need the original values for an underlining operation

    nTextX = nX
    nTextY = nY

    PDFTextWordSpacing(uTextDescriptor.WordSpacing)

    If uTextDescriptor.CharSpacing = 0 Then

      PDFTextSpacing(uDescriptor.FontCharSpacingAdjust)

    Else

       PDFTextSpacing(uTextDescriptor.CharSpacing)

    End If

    SetNonStrokingColor(nFontColor)
    PDFTextFont(sFontID,nFontSize)
    PDFTextLocation(nX,nY,uTextDescriptor.Angle)
    PDFAddText(sText,0,uTextDescriptor.NewLine)
    PDFEndText()

    If uTextDescriptor.Underline = FONT_UNDERLINE Then

' Get current font metrics for vertical displacement and thickness
' and override the LineDescriptor width

       nTextY = nTextY - (((uDescriptor.FontUnderlinePosition + uDescriptor.FontDescent) * nFontSize) / 1000)
       uTextDescriptor.LineDescriptor.Width = (uDescriptor.FontUnderlineThickness * nFontSize) / 1000
       PDFStartLine(nTextX,nTextY,uTextDescriptor.LineDescriptor)
       PDFMoveTo(nTextX + nTextSize,nTextY)
       PDFDrawLine()
       RestoreGraphicsState()

    End If

    If nPageWordSpacing >= 0 Then
       PDFTextWordSpacing(nPageWordSpacing)
    Else
       PDFTextWordSpacing(0)
    End If

    If nPageCharacterSpacing >= 0 Then
       PDFTextSpacing(nPageCharacterSpacing)
    Else
       PDFTextSpacing(0)
    End If

End Sub

Private SUB cPDF.RotationMatrix(BYVAL nAngle AS DOUBLE, BYREF nA AS DOUBLE, BYREF nB AS DOUBLE, BYREF nC AS DOUBLE, BYREF nD AS DOUBLE)

    nAngle = (nAngle * -1) * PI / 180       ' Convert to radians
    nA = COS(nAngle)
    nC = SIN(nAngle)
    nB = nC * -1
    nD = nA

End Sub

' =====================================================================================
' Insert Text Metric a b c d x y
' =====================================================================================

Private SUB cPDF.PDFTextRotateStream(BYVAL nAngle AS DOUBLE, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE)

' a=Horizontal Scaling
' b=Horizontal Rotation
' c=Vertical Scaling
' d=Vertical Rotation
' x=Vertical point location in the user space
' y=Horizontal point location in the user space

DIM nA        AS DOUBLE
DIM nB        AS DOUBLE
DIM nC        AS DOUBLE
DIM nD        AS DOUBLE

    RotationMatrix(nAngle,nA,nB,nC,nD)

    BuildObject(sTempStream,TRIM(FORMAT(nA,"#####.0####")) + " " + _
                TRIM(FORMAT(nB,"#####.0####")) + " " + _
                TRIM(FORMAT(nC,"#####.0####")) + " " + _
                TRIM(FORMAT(nD,"#####.0####")) + " " + _
                FormatPoint(nX) + " " + _
                FormatPoint(nY) + " Tm")

End Sub

' =====================================================================================
' Begin a new page
' =====================================================================================

Private SUB cPDF.PDFNewPage()

DIM uCanvas       AS PageCanvas
DIM uMetrics      AS PageMetrics
DIM sPaperName    AS DWSTRING
DIM nPaperHeight  AS DOUBLE
DIM nPaperWidth   AS DOUBLE

' Ensure current page is finished

    PDFEndPage()

' Get current page and clone setup

    GetCurrentCanvas(uCanvas)

    uCanvas.ObjectNumber = 0
    uCanvas.StreamObject = 0
    uCanvas.StreamComplete = False

' Setup Page Metrics

    PDFCurrentPageMetrics(uMetrics)

    uCanvas.ObjectNumber = 0
    uCanvas.StreamObject = 0
    uCanvas.StreamComplete = False
    uCanvas.Width = uMetrics.Width
    uCanvas.Height = uMetrics.Height
    uCanvas.LeftMargin = uMetrics.LeftMargin
    uCanvas.TopMargin = uMetrics.TopMargin
    uCanvas.RightMargin = uMetrics.RightMargin
    uCanvas.BottomMargin = uMetrics.BottomMargin
    uCanvas.DrawingHeight = uMetrics.DrawingHeight
    uCanvas.DrawingWidth = uMetrics.DrawingWidth
    uCanvas.Orientation = uMetrics.Orientation

    CreateCanvas(uCanvas)

' Start a stream object for the page

    StartStream()

End Sub

' =====================================================================================
' Get PDF Paper Size Metrics
' =====================================================================================

Private SUB cPDF.PDFPageMetrics()

DIM uPDFPaper    AS PDFPaper
DIM dv           AS DVARIANT

   If nCurrentPaperID < PDF_PAPER_A0 ORELSE nCurrentPaperID > PDF_PAPER_METRIC_ROYAL_OCTAVO THEN
      nCurrentPaperID = PDF_PAPER_A4
   End If

   dv = oPaperList.Item("P" + str(nCurrentPaperID))
   dv.ToBuffer(@uPDFPaper, SIZEOF(uPDFPaper))
   sCurrentPaperName = uPDFPaper.sPaperName
   nCurrentHeight = uPDFPaper.nPaperHeight
   nCurrentWidth = uPDFPaper.nPaperWidth
 
End Sub

' =====================================================================================
' Maintain table of object offsets
' =====================================================================================

Private SUB cPDF.SaveOffset(BYVAL nOffset AS ULONG)

DIM nCurrentOffset       AS ULONG
DIM nLastIndex           AS ULONG

    nLastIndex = oObjectOffsetList.Count
    nCurrentOffset = 0

    If nLastIndex > 0 Then
        nCurrentOffset = VAL(oObjectOffsetList.Item(nLastIndex))
    End If

    oObjectOffsetList.Add(nCurrentOffset + nOffset)

End Sub

' =====================================================================================
' Add a new canvas
' =====================================================================================

Private SUB cPDF.CreateCanvas(BYREF uCanvas As PageCanvas)

   AppendElementToArray (arCanvas, uCanvas)
   oPageStreamList.Add("")

End Sub

Private SUB cPDF.PDFCurrentPageMetrics(BYREF uMetrics AS PageMetrics)

DIM nWidth   AS DOUBLE
DIM nHeight  AS DOUBLE

    PDFPageMetrics()
    nWidth = nCurrentWidth
    nHeight = nCurrentHeight

    If nCurrentPaperOrientation = PDFPAGE_LANDSCAPE Then
           Swap nWidth, nHeight
    End If
 
    uMetrics.Width = nWidth
    uMetrics.Height = nHeight
    uMetrics.LeftMargin = nCurrentLeftMargin
    uMetrics.TopMargin = nCurrentTopMargin
    uMetrics.RightMargin = nCurrentRightMargin
    uMetrics.BottomMargin = nCurrentBottomMargin
    uMetrics.DrawingHeight = nHeight - nCurrentTopMargin - nCurrentBottomMargin
    uMetrics.DrawingWidth = nWidth - nCurrentLeftMargin - nCurrentRightMargin
    uMetrics.Orientation = nCurrentPaperOrientation

End Sub

' =====================================================================================
' Return current canvas
' =====================================================================================

Private SUB cPDF.GetCurrentCanvas(BYREF uCanvas AS PageCanvas)

     GetCanvas(UBOUND(arCanvas),uCanvas)

End Sub

' =====================================================================================
' Return specified canvas
' =====================================================================================

Private SUB cPDF.GetCanvas(BYVAL nIndex AS LONG, BYREF uCanvas AS PageCanvas)

   uCanvas = arCanvas(nIndex) 

End Sub

' =====================================================================================
' Show Text at current postion
' =====================================================================================

Private SUB cPDF.PDFShowText(BYREF sText AS DWSTRING)

    BuildObject(sTempStream,"(" + sText + ") Tj")

End Sub

' =====================================================================================
' Add a string to the strings object
' =====================================================================================

Private FUNCTION cPDF.CreateStringID(BYVAL sString AS DWSTRING) AS DWSTRING

DIM uPDFString     AS PDFStringID

   uPDFString.sStringID = "SL" + str(nNextStringID)
   uPDFString.sStringText = sString
   AppendElementToArray(arStringID,uPDFString)
   nNextStringID =  nNextStringID + 1

   RETURN uPDFString.sStringID

End Function

' =====================================================================================
' Retrieve a string in the strings object
' =====================================================================================

Private FUNCTION cPDF.GetStringID(BYREF sStringID AS DWSTRING) AS DWSTRING

DIM sString    AS DWSTRING = ""
DIM nIndex     AS LONG

   If UBOUND(arStringID) >= 0 Then

      For nIndex = LBOUND(arStringID) to UBOUND(arStringID)
         If arStringID(nIndex).sStringID = sStringID Then
            sString = arStringID(nIndex).sStringText
            EXIT FOR
         End If
      Next

   End If

   RETURN sString

End Function

' =====================================================================================
' Add a font and font size to the text stream
' Use the current default if no FontID is provided
' =====================================================================================

Private SUB cPDF.PDFTextFont(BYVAL sFontID AS DWSTRING, BYVAL nFontSize AS LONG)

DIM sFont AS DWSTRING

   If LEN(sFontID) = 0 Then
       sFont = sDefaultFontID
   ELSE
       sFont = sFontID
   End If

   If nFontSize < 1 Then
      nFontSize = nDefaultFontSize
   End If

   BuildObject(sTempStream,"/" + sFont + " " + Format(IIF(nFontSize < 1,nDefaultFontSize,nFontSize)) + " Tf")

End Sub

' =====================================================================================
' Set next text location with optional rotation
' =====================================================================================

Private SUB cPDF.PDFTextLocation(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nAngle AS CONST LONG = -1, BYVAL nSet AS CONST LONG = 0)

    If nAngle <> ITEM_IGNORE Then

       PDFTextRotateStream(nAngle,0,0)

    End If

    PDFTextMoveTo(nX,nY,nSet)

End Sub

' =====================================================================================
' Move to the start of the next line.
' if nReset is <> 0 - sets the leading parameter in the text state
' =====================================================================================

Private SUB cPDF.PDFTextMoveTo(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, ByVal nSet AS CONST LONG = 0)

DIM uCanvas    AS PageCanvas

    GetCurrentCanvas(uCanvas)
    DrawingPoints(uCanvas,nX,nY)

    BuildObject(sTempStream,FormatPoint(nX) + " " + FormatPoint(nY) + IIF(nSet = 0," Td"," TD"))

End Sub

' Placeholders are inserted as PDF comments and serve as triggers for additional objects
' to be added to the page stream object for every page

' =====================================================================================
' Create a Placeholder Text object
' =====================================================================================

Private SUB cPDF.PDFPlaceHolderTextCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uText AS TextDescriptor, _
                                           BYVAL sPlaceHolderID AS DWSTRING, BYVAL sText AS DWSTRING)

DIM uPlaceHolderObject   AS PlaceHolderObject
DIM sStreamSave          AS STRING
DIM bExists              AS BOOLEAN = False
DIM nIndex               AS LONG

   sStreamSave = sTempStream
   sTempStream = ""

   uPlaceHolderObject.ID = "%" + UCASE(sPlaceHolderID)

' Check if Place Holder was previously defined

   If LBOUND(arPlaceHolderObject) >= 0 Then

      For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

        If arPlaceHolderObject(nIndex).ID = uPlaceHolderObject.ID Then
           bExists = True
           EXIT For
        End If

      Next

   End If

   If bExists = False Then

      PDFWriteText(nX,nY,uText,sText)
      uPlaceHolderObject.ObjectID = CreateStringID(sTempStream)
      AppendElementToArray(arPlaceHolderObject,uPlaceHolderObject)

   End If

   sTempStream = sStreamSave

End Sub

' =====================================================================================
' Create a Placeholder line object
' =====================================================================================

Private SUB cPDF.PDFPlaceHolderLineCreate (BYVAL nFromX AS DOUBLE, BYVAL nFromY AS DOUBLE, BYVAL nToX AS DOUBLE, _
                                           BYVAL nToY AS DOUBLE, BYREF uLine AS LineDescriptor, BYVAL sPlaceHolderID AS DWSTRING)

DIM uPlaceHolderObject   AS PlaceHolderObject
DIM sStreamSave          AS STRING
DIM bExists              AS BOOLEAN = False
DIM nIndex               AS LONG

   sStreamSave = sTempStream
   sTempStream = ""

   uPlaceHolderObject.ID = "%" + UCASE(sPlaceHolderID)

' Check if Place Holder was previously defined

   If LBOUND(arPlaceHolderObject) >= 0 Then

      For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

        If arPlaceHolderObject(nIndex).ID = uPlaceHolderObject.ID Then
           bExists = True
           EXIT For
        End If

      Next

   End If

   If bExists = False Then

      PDFLineAdd (nFromX,nFromY,nToX,nToY,uLine)
      uPlaceHolderObject.ObjectID = CreateStringID(sTempStream)
      AppendElementToArray(arPlaceHolderObject,uPlaceHolderObject)

   End If

   sTempStream = sStreamSave

End Sub

' =====================================================================================
' Create a Placeholder line object
' =====================================================================================

Private SUB cPDF.PDFPlaceHolderRectangleCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uRectangle AS RectangleDescriptor, _
                                                BYVAL sPlaceHolderID AS DWSTRING)

DIM uPlaceHolderObject   AS PlaceHolderObject
DIM sStreamSave          AS STRING
DIM bExists              AS BOOLEAN = False
DIM nIndex               AS LONG

   sStreamSave = sTempStream
   sTempStream = ""

   uPlaceHolderObject.ID = "%" + UCASE(sPlaceHolderID)

' Check if Place Holder was previously defined

   If LBOUND(arPlaceHolderObject) >= 0 Then

      For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

        If arPlaceHolderObject(nIndex).ID = uPlaceHolderObject.ID Then
           bExists = True
           EXIT For
        End If

      Next

   End If

   If bExists = False Then

      PDFRectangle(nX,nY,uRectangle)
      uPlaceHolderObject.ObjectID = CreateStringID(sTempStream)
      AppendElementToArray(arPlaceHolderObject,uPlaceHolderObject)

   End If

   sTempStream = sStreamSave

End Sub

' =====================================================================================
' Create a Placeholder ellispe object
' =====================================================================================

Private Sub cPDF.PDFPlaceHolderEllispeCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, _ 
                                              BYVAL nWidth AS DOUBLE, BYVAL nOutlineColor AS LONG, BYVAL nFillColor AS LONG, _
                                              BYVAL sPlaceHolderID AS DWSTRING)

DIM uPlaceHolderObject   AS PlaceHolderObject
DIM sStreamSave          AS STRING
DIM bExists              AS BOOLEAN = False
DIM nIndex               AS LONG

   sStreamSave = sTempStream
   sTempStream = ""

   uPlaceHolderObject.ID = "%" + UCASE(sPlaceHolderID)

' Check if Place Holder was previously defined

   If LBOUND(arPlaceHolderObject) >= 0 Then

      For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

        If arPlaceHolderObject(nIndex).ID = uPlaceHolderObject.ID Then
           bExists = True
           EXIT For
        End If

      Next

   End If

   If bExists = False Then

      PDFEllispe(nX,nY,nHeight,nWidth,nOutlineColor,nFillColor)
      uPlaceHolderObject.ObjectID = CreateStringID(sTempStream)
      AppendElementToArray(arPlaceHolderObject,uPlaceHolderObject)

   End If

   sTempStream = sStreamSave

End Sub

' =====================================================================================
' Create a Placeholder regular polygon object
' =====================================================================================

Private Sub cPDF.PDFPlaceHolderRegularPolygonCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, ByVal nRadius AS DOUBLE, _
                                                     BYVAL nSides AS LONG, BYVAL nFillColor AS LONG, BYREF uLine AS LineDescriptor, _
                                                     BYVAL sPlaceHolderID AS DWSTRING)

DIM uPlaceHolderObject   AS PlaceHolderObject
DIM sStreamSave          AS STRING
DIM bExists              AS BOOLEAN = False
DIM nIndex               AS LONG

   sStreamSave = sTempStream
   sTempStream = ""

   uPlaceHolderObject.ID = "%" + UCASE(sPlaceHolderID)

' Check if Place Holder was previously defined

   If LBOUND(arPlaceHolderObject) >= 0 Then

      For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

        If arPlaceHolderObject(nIndex).ID = uPlaceHolderObject.ID Then
           bExists = True
           EXIT For
        End If

      Next

   End If

   If bExists = False Then

      PDFRegularPolygon(nX,nY,nRadius,nSides,nFillColor,uLine)
      uPlaceHolderObject.ObjectID = CreateStringID(sTempStream)
      AppendElementToArray(arPlaceHolderObject,uPlaceHolderObject)

   End If

   sTempStream = sStreamSave

End Sub

' =====================================================================================
' Create a Placeholder image object
' =====================================================================================

Private Sub cPDF.PDFPlaceHolderWriteImageCreate (BYREF sImageID As DWSTRING, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                                 BYREF uImageOptions AS ImageOptions, BYVAL sPlaceHolderID AS DWSTRING)

DIM uPlaceHolderObject   AS PlaceHolderObject
DIM sStreamSave          AS STRING
DIM bExists              AS BOOLEAN = False
DIM nIndex               AS LONG

   sStreamSave = sTempStream
   sTempStream = ""

   uPlaceHolderObject.ID = "%" + UCASE(sPlaceHolderID)

' Check if Place Holder was previously defined

   If LBOUND(arPlaceHolderObject) >= 0 Then

      For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

        If arPlaceHolderObject(nIndex).ID = uPlaceHolderObject.ID Then
           bExists = True
           EXIT For
        End If

      Next

   End If

   If bExists = False Then

      PDFWriteImage(sImageID,nX,nY,uImageOptions)
      uPlaceHolderObject.ObjectID = CreateStringID(sTempStream)
      AppendElementToArray(arPlaceHolderObject,uPlaceHolderObject)

   End If

   sTempStream = sStreamSave

End Sub

' =====================================================================================
' Create a Placeholder multiline text object
' =====================================================================================

Private Sub cPDF.PDFPlaceHolderMultiLineCreate (BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uMultiLine As MultilineTextDescriptor, _
                                                BYREF sString AS DWSTRING, BYVAL sPlaceHolderID AS DWSTRING)

DIM uPlaceHolderObject   AS PlaceHolderObject
DIM sStreamSave          AS STRING
DIM bExists              AS BOOLEAN = False
DIM nIndex               AS LONG

   sStreamSave = sTempStream
   sTempStream = ""

   uPlaceHolderObject.ID = "%" + UCASE(sPlaceHolderID)

' Check if Place Holder was previously defined

   If LBOUND(arPlaceHolderObject) >= 0 Then

      For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

        If arPlaceHolderObject(nIndex).ID = uPlaceHolderObject.ID Then
           bExists = True
           EXIT For
        End If

      Next

   End If

   If bExists = False Then

      PDFMultiLineTextBox (nX,nY,uMultiLine,sString)
      uPlaceHolderObject.ObjectID = CreateStringID(sTempStream)
      AppendElementToArray(arPlaceHolderObject,uPlaceHolderObject)

   End If

   sTempStream = sStreamSave

End Sub

' =====================================================================================
' Draw a rectangle
' =====================================================================================

Private Sub cPDF.PDFRectangle(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYREF uRectangle AS RectangleDescriptor)

' Check for square or rounded rectangle

    If uRectangle.Radius = 0 ORELSE uRectangle.Radius = ITEM_IGNORE Then

       PDFSquareRectangle(nX, nY, uRectangle.Height, uRectangle.Width, uRectangle.FillColor, uRectangle.LineAttributes)

    Else

       PDFRoundedRectangle(nX, nY, uRectangle.Height, uRectangle.Width, uRectangle.FillColor, _
                           uRectangle.LineAttributes, uRectangle.Radius, uRectangle.Corners)

    End If

End Sub

Private SUB cPDF.UpdateCanvas(BYVAL nIndex AS LONG, BYREF uCanvas AS PageCanvas)

    arCanvas(nIndex) = uCanvas

End Sub

Private SUB cPDF.UpdateCurrentCanvas(BYREF uCanvas AS PageCanvas)

   UpdateCanvas(UBOUND(arCanvas),uCanvas)

End Sub

' =====================================================================================
' Close out content stream for the current page
' =====================================================================================

Private SUB cPDF.EndStream()

DIM uCanvas       AS PageCanvas

    GetCurrentCanvas(uCanvas)

    If uCanvas.StreamComplete = False Then

' Save the page content stream

        oPageStreamList.Replace(UBOUND(arCanvas) + 1,sTempStream)
        uCanvas.StreamComplete = True

        UpdateCurrentCanvas(uCanvas)

    End If

    sTempStream = ""

End Sub

Private SUB cPDF.ReplacePlaceHolders(BYVAL nCurrentPageNumber AS LONG, BYVAL nTotalPages AS LONG)

DIM nIndex             AS LONG
DIM sText              AS DWSTRING

   If UBOUND(arPlaceHolderObject) >= 0 Then

       For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

' See if sPlaceholder is in the stream object

         If AfxStrTally(sTempStream, arPlaceHolderObject(nIndex).ID) > 0 Then

            sText = GetStringID(arPlaceHolderObject(nIndex).ObjectID)

' Replace the special tags for page numbering - %pageno and %totalpages

               StringReplace(sText,"%pageno",TRIM(FORMAT(nCurrentPageNumber,"###,###")))
               StringReplace(sText,"%totalpages",TRIM(FORMAT(nTotalPages,"###,###")))

               sTempStream = sTempStream + sText

          End If

        Next

   End If

End Sub

' =====================================================================================
' Compress the stream with Zlib if available
' =====================================================================================

Private SUB cPDF.PDFCompressStream(BYVAL nObjectID AS LONG, BYREF sUncompressed AS STRING, BYREF sStreamObject AS STRING)

DIM sCompressed       AS STRING
DIM bCompress         AS BOOLEAN = False

   sStreamObject = ""
   BuildObject(sStreamObject,FORMAT(nObjectID) + " 0 obj")

   If hZlib <> 0 Then

' Compress stream

      bCompress = PDFFlateCompress(sUncompressed,sCompressed)

      If bCompress = True Then

         BuildObject(sStreamObject,"<<")
         BuildObject(sStreamObject,"/Length " + FORMAT(Len(sCompressed)))
         BuildObject(sStreamObject,"/Filter /FlateDecode")
         BuildObject(sStreamObject,">>")
         BuildObject(sStreamObject,"stream")
         BuildObject(sStreamObject,sCompressed)

      End If

   End If

   If bCompress = False Then

' No Compression

      BuildObject(sStreamObject,"<<")
      BuildObject(sStreamObject,"/Length " + FORMAT(LEN(sUncompressed)))
      BuildObject(sStreamObject,">>")
      BuildObject(sStreamObject,"stream")
      sStreamObject = sStreamObject + sUncompressed

   End If

   BuildObject(sStreamObject,"endstream")
   BuildObject(sStreamObject,"endobj")

End Sub

Private FUNCTION cPDF.PDFFlateCompress (BYREF sUncompressed AS STRING, BYREF sCompressed AS STRING) AS BOOLEAN

DIM bResult           AS BOOLEAN = False
DIM nUncompressedSize AS ULONG
DIM nBufferSize       AS ULONG
DIM nResult           AS LONG
DIM sBuffer           AS STRING

   sCompressed = ""
   nUncompressedSize = LEN(sUncompressed)

   If nUncompressedSize > 0 Then

      nBufferSize = ZLIBCompressBound(nUncompressedSize)
      sBuffer = SPACE(nBufferSize)

' Compress the string

      nResult = ZLibCompress(STRPTR(sBuffer),nBufferSize,STRPTR(sUncompressed),nUncompressedSize)

      If nResult = 0 Then

         If nBufferSize > 0 Then

            sCompressed = SPACE(nBufferSize)
            memcpy(STRPTR(sCompressed),STRPTR(sBuffer),nBufferSize)

            bResult = True

         Else
            
            bResult = False

         End If

      Else

         bResult = False

      End If

   Else

      bResult = False

   End If

   RETURN bResult

End Function

' =====================================================================================
' Add an outline or bookmark section to current page
' =====================================================================================

Private FUNCTION cPDF.PDFAddOutlineSection(BYVAL sName AS DWSTRING) AS BOOLEAN

DIM bResult           AS BOOLEAN = True
DIM nIndex            AS LONG
Dim uOutlineSection   AS OutlineSection
DIM nCanvasIndex      AS LONG = UBOUND(arCanvas)

   sLastErrorDescription = ""

   If UBOUND(arSection) >= 0 Then

' Chevk if a page section is already defined

      For nIndex = LBOUND(arSection) to UBOUND(arSection)

          If arSection(nIndex).arCanvasIndex = nCanvasIndex Then

            bResult = False
            sLastErrorDescription = "Outline section " + sName + " already exists."
            Exit FOR

          End If

      Next

   End If

   If bResult = True Then

' Chevk if a page subsection is already defined

      If UBOUND(arSubsection) >= 0 Then

         For nIndex = LBOUND(arSubSection) to UBOUND(arSubSection)

            If arSubSection(nIndex).arCanvasIndex = nCanvasIndex Then

              bResult = False
              Exit FOR

            End If

        Next

      End If

   End If

   If bResult = True Then

      uOutlineSection.arCanvasIndex = nCanvasIndex
      uOutlineSection.StringID = CreateStringID(sName)
      AppendElementToArray(arSection,uOutlineSection)

   End IF

RETURN bResult

End Function

' =====================================================================================
' Add an outline or bookmark subsection to current page
' =====================================================================================

Private FUNCTION cPDF.PDFAddOutlineSubSection(BYVAL sName AS DWSTRING) AS BOOLEAN

DIM bResult           AS BOOLEAN = True
DIM nIndex            AS LONG
Dim uOutlineSection   AS OutlineSection
DIM nCanvasIndex      AS LONG = UBOUND(arCanvas)

   sLastErrorDescription = ""

   If UBOUND(arSection) >= 0 Then

' Chevk if a page section is already defined

      For nIndex = LBOUND(arSection) to UBOUND(arSection)

          If arSection(nIndex).arCanvasIndex = nCanvasIndex Then

            bResult = False
            sLastErrorDescription = "Outline page section not found."
            Exit FOR

          End If

      Next

   Else

' Section must be defined for subsection to attach to

      bResult = False

   End If

   If bResult = True Then

' Chevk if a page subsection is already defined

      If UBOUND(arSubsection) >= 0 Then

         For nIndex = LBOUND(arSubSection) to UBOUND(arSubSection)

            If arSubSection(nIndex).arCanvasIndex = nCanvasIndex Then

              bResult = False
              sLastErrorDescription = "Outline subsection " + sName + " already exists."
              Exit FOR

            End If

        Next

      End If

   End If


   If bResult = True Then

      uOutlineSection.arCanvasIndex = nCanvasIndex
      uOutlineSection.StringID = CreateStringID(sName)
      uOutlineSection.SectionIndex = UBOUND(arSection)
      AppendElementToArray(arSubSection,uOutlineSection)

   End IF

   RETURN bResult

End Function

' =====================================================================================
' Close out content streaming, create the PDF document if a name is provided, else
' return the completed document
' =====================================================================================

Private FUNCTION cPDF.PDFEndDocument(BYREF sDocument AS DWSTRING, BYVAL nOpenPDF AS CONST LONG = 0) AS BOOLEAN

DIM uCanvas               AS PageCanvas
DIM uDescriptor           AS FontDescriptor
DIM sPDFAssociation       AS WSTRING * MAX_PATH
DIM sPDFDocument          AS WSTRING * MAX_PATH
DIM sFontID               AS DWSTRING
DIM dvFont                AS DVARIANT
DIM dvImage               AS DVARIANT
DIM sImageID              AS DWSTRING
DIM sImageStream          AS STRING
DIM sStreamObject         AS STRING
DIM sEOFMarker            AS STRING = "%%EOF"
DIM sDocumentID           AS DWSTRING
DIM sOutline              AS DWSTRING
DIM nRootOutlineObject    AS LONG
DIM nPageNumber           AS LONG
DIM nIndex                AS LONG
DIM nEmbedIndex           AS LONG
DIM nTotalPages           AS LONG
DIM nPageTreeObject       AS LONG
DIM nProcSetObject        AS LONG
DIM nCatalogObject        AS LONG
DIM nRowIndex             AS LONG
DIM nColumnIndex          AS LONG
DIM arWidths()            AS LONG
DIM nObject               AS LONG
DIM nOffset               AS LONG
DIM nStreamOffset         AS LONG
DIM dwBytesWritten        AS DWORD
DIM hFile                 AS HANDLE
DIM nFindResult           AS HINSTANCE
DIM nEmbedIndexActive     AS LONG
DIM bReturn               AS BOOLEAN = True

   sLastErrorDescription = ""

' Close out current page content if necessary

   If LEN(sTempStream) <> 0 Then
      EndStream()
   End If

   nTotalPages = UBOUND(arCanvas) + 1

' Create page content streams

    For nIndex = 1 To nTotalPages

        sTempStream = oPageStreamList.Item(nIndex)

        GetCanvas(nIndex - 1,uCanvas)

' Look for placeholders and add objects to page stream

        ReplacePlaceHolders(nIndex,nTotalPages)

        nCurrentObjectNumber = nCurrentObjectNumber + 1

' Compress stream

        PDFCompressStream(nCurrentObjectNumber,sTempStream,sStreamObject)

        SaveOffset(LEN(sStreamObject))
        sPDFStream = sPDFStream + sStreamObject

        uCanvas.StreamComplete = True
        uCanvas.StreamObject = nCurrentObjectNumber
        UpdateCanvas(nIndex - 1,uCanvas)

    Next

' Build Font objects

    sTempStream = ""

     For nIndex = LBOUND(arFontID) to UBOUND(arFontID)

         sFontID = arFontID(nIndex).sFontID

         If arFontID(nIndex).uFont.FontReferenced <> 1 Then
            CONTINUE FOR
         End If

' Is font to be embedded?

         nEmbedIndexActive = -1

         If LBOUND(arFontEmbed) >= 0 Then

            For nEmbedIndex = LBOUND(arFontEmbed) to UBOUND(arFontEmbed)

               If arFontEmbed(nEmbedIndex).sFontID = sFontID Then

                  nCurrentObjectNumber = nCurrentObjectNumber + 1
                  arFontEmbed(nEmbedIndex).nFontObject = nCurrentObjectNumber
                  BuildObject(sTempStream,FORMAT(nCurrentObjectNumber) + " 0 obj")
                  BuildObject(sTempStream,"<<")

                  If arFontEmbed(nEmbedIndex).nUncompressedSize <> arFontEmbed(nEmbedIndex).nCompressedSize Then

                     BuildObject(sTempStream,"/Filter /FlateDecode") 

                  End If

                  BuildObject(sTempStream,"/Length " + FORMAT(arFontEmbed(nEmbedIndex).nCompressedSize))
                  BuildObject(sTempStream,"/Length1 " + FORMAT(arFontEmbed(nEmbedIndex).nUncompressedSize))
                  BuildObject(sTempStream,">>")
                  BuildObject(sTempStream,"stream")
                  BuildObject(sTempStream,arFontEmbed(nEmbedIndex).sCompressedFont)
                  BuildObject(sTempStream,"endstream")
                  BuildObject(sTempStream,"endobj")
                  SaveOffset(Len(sTempStream))
                  sPDFStream = sPDFStream + sTempStream
                  sTempStream = ""                
                  nEmbedIndexActive = nEmbedIndex

                  EXIT FOR

               End If

            Next

         End If

         nCurrentObjectNumber = nCurrentObjectNumber + 1
         arFontID(nIndex).uFont.FontDescriptorObject = nCurrentObjectNumber
         BuildObject(sTempStream,FORMAT(nCurrentObjectNumber) + " 0 obj")

' Build the font descriptor object

         BuildObject(sTempStream,"<<")
         BuildObject(sTempStream,"/Type /FontDescriptor")
         BuildObject(sTempStream,"/Ascent " + FORMAT(arFontID(nIndex).uFont.FontAscent))
         BuildObject(sTempStream,"/CapHeight " + FORMAT(arFontID(nIndex).uFont.FontCapHeight))
         BuildObject(sTempStream,"/Descent " + FORMAT(arFontID(nIndex).uFont.FontDescent))
         BuildObject(sTempStream,"/Flags " + FORMAT(arFontID(nIndex).uFont.FontFlags))
         BuildObject(sTempStream,"/FontBBox [" + _
                FORMAT(arFontID(nIndex).uFont.FontRectLeft) + " " + _
                FORMAT(arFontID(nIndex).uFont.FontRectTop) + " " + _
                FORMAT(arFontID(nIndex).uFont.FontRectRight) + " " + _
                FORMAT(arFontID(nIndex).uFont.FontRectBottom) + "]")
         BuildObject(sTempStream,"/FontName /" + arFontID(nIndex).uFont.FontName)
         BuildObject(sTempStream,"/ItalicAngle " + FORMAT(arFontID(nIndex).uFont.FontItalicAngle,"##.0#"))
         BuildObject(sTempStream,"/StemV " + FORMAT(arFontID(nIndex).uFont.FontStemV))
         BuildObject(sTempStream,"/FontWeight " + FORMAT(arFontID(nIndex).uFont.FontWeight))

         If nEmbedIndexActive >= 0 Then

            BuildObject(sTempStream,"/FontFile2 " + FORMAT(arFontEmbed(nEmbedIndexActive).nFontObject) + " 0 R")
          
         End If

         BuildObject(sTempStream,">>")
         BuildObject(sTempStream,"endobj")
         SaveOffset(Len(sTempStream))
         sPDFStream = sPDFStream + sTempStream
         sTempStream = ""

' Build the font widths object

         If nEmbedIndexActive < 0 Then 'ANDALSO arFontID(nIndex).uFont.FontStandard <> 1 Then

            PDFFontWidths(sFontID, arWidths())
            nCurrentObjectNumber = nCurrentObjectNumber + 1
            arFontID(nIndex).uFont.FontWidthObject = nCurrentObjectNumber
            BuildObject(sTempStream,FORMAT(nCurrentObjectNumber) + " 0 obj")
            BuildObject(sTempStream,"[")

            For nRowIndex = 1 To 16
               For nColumnIndex = 0 To 15
                 sTempStream = sTempStream + FORMAT(arWidths ((nRowIndex * 16 - 16) + nColumnIndex)) + " "
               Next
               sTempStream = RTRIM(sTempStream) + CRLF
            Next

            BuildObject(sTempStream,"]")
            BuildObject(sTempStream,"endobj")
            SaveOffset(Len(sTempStream))
            sPDFStream = sPDFStream + sTempStream
            sTempStream = ""

         End If

' Build font object

         nCurrentObjectNumber = nCurrentObjectNumber + 1
         arFontID(nIndex).uFont.FontObject = nCurrentObjectNumber
         BuildObject(sTempStream,FORMAT(nCurrentObjectNumber) + " 0 obj")
         BuildObject(sTempStream,"<<")
         BuildObject(sTempStream,"/Type /Font")

         If arFontID(nIndex).uFont.FontType = FONT_TYPE1 Then
            BuildObject(sTempStream,"/SubType /Type1")
         Else
            BuildObject(sTempStream,"/Subtype /TrueType")
         End If

         BuildObject(sTempStream,"/BaseFont /" + arFontID(nIndex).uFont.FontName)
         BuildObject(sTempStream,"/FontDescriptor " + FORMAT(arFontID(nIndex).uFont.FontDescriptorObject) + " 0 R")
         BuildObject(sTempStream,"/Encoding /WinAnsiEncoding")

         If nEmbedIndexActive < 0 Then 'ANDALSO arFontID(nIndex).uFont.FontStandard <> 1 Then    

            BuildObject(sTempStream,"/Widths " + FORMAT(arFontID(nIndex).uFont.FontWidthObject) + " 0 R")
            BuildObject(sTempStream,"/FirstChar 0")
            BuildObject(sTempStream,"/LastChar 255")

         End If

         BuildObject(sTempStream,">>")
         BuildObject(sTempStream,"endobj")

' Update the font descriptor object

         SaveOffset(Len(sTempStream))
         sPDFStream = sPDFStream + sTempStream
         sTempStream = ""

    Next

    sTempStream = ""

' Build Image Objects

    If UBOUND(arImageID) >= 0 ANDALSO UBOUND(arImageStream) >= 0 Then

       For nIndex = LBOUND(arImageID) To UBOUND(arImageID)

          nCurrentObjectNumber = nCurrentObjectNumber + 1
          arImageID(nIndex).uImage.ImageDescriptorObject = nCurrentObjectNumber
          BuildObject(sTempStream,FORMAT(nCurrentObjectNumber) + " 0 obj")
          BuildObject(sTempStream,"<<")
          BuildObject(sTempStream,"/Name /" + arImageID(nIndex).sImageID)
          BuildObject(sTempStream,"/Type /XObject")
          BuildObject(sTempStream,"/Subtype /Image")
          BuildObject(sTempStream,"/Filter /DCTDecode")
          BuildObject(sTempStream,"/ColorSpace /DeviceRGB")
          BuildObject(sTempStream,"/Width " + FORMAT(arImageID(nIndex).uImage.ImagePixelWidth))
          BuildObject(sTempStream,"/Height " + FORMAT(arImageID(nIndex).uImage.ImagePixelHeight))
          BuildObject(sTempStream,"/BitsPerComponent 8")
          BuildObject(sTempStream,"/Length " + FORMAT(arImageID(nIndex).uImage.ImageSize))
          BuildObject(sTempStream,">>")
          BuildObject(sTempStream,"stream")
          BuildObject(sTempStream,arImageStream(nIndex))
          BuildObject(sTempStream,"endstream")
          BuildObject(sTempStream,"endobj")
          SaveOffset(Len(sTempStream))
          sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
          memcpy(STRPTR(sPDFStream) + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))
          sTempStream = ""

       Next

    End If

     nCurrentObjectNumber = nCurrentObjectNumber + 1
     nPageTreeObject = nCurrentObjectNumber
     nCurrentObjectNumber = nCurrentObjectNumber
     nCurrentObjectNumber = nCurrentObjectNumber + 1
     nProcSetObject = nCurrentObjectNumber

' Assign the page object numbers

' We will be creating the page tree node and the procedure set array
' objects before the page objects

     For nIndex = 1 to UBOUND(arCanvas) + 1

        nCurrentObjectNumber = nCurrentObjectNumber + 1
        GetCanvas(nIndex - 1,uCanvas)
        uCanvas.ObjectNumber = nCurrentObjectNumber
        UpdateCanvas(nIndex - 1,uCanvas)

    Next

' Create Page Tree Node

    sTempStream = ""

    BuildObject(sTempStream,FORMAT(nPageTreeObject) + " 0 obj")
    BuildObject(sTempStream,"<<")
    BuildObject(sTempStream,"/Type /Pages")
    BuildObject(sTempStream,"/Kids")
    BuildObject(sTempStream,"[")

    For nIndex = 1 to UBOUND(arCanvas) + 1

        GetCanvas(nIndex - 1,uCanvas)
        BuildObject(sTempStream,FORMAT(uCanvas.ObjectNumber) + " 0 R")

    Next

    BuildObject(sTempStream,"]")
    BuildObject(sTempStream,"/Count " + FORMAT(UBOUND(arCanvas) + 1))
    BuildObject(sTempStream,">>")
    BuildObject(sTempStream,"endobj")

    SaveOffset(Len(sTempStream))
    sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
    memcpy(STRPTR(sPDFStream)  + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))
    sTempStream = ""

' Create Procedure Set Array

    BuildObject(sTempStream,FORMAT(nProcSetObject) + " 0 obj")
    BuildObject(sTempStream,"<<") 
    BuildObject(sTempStream,"  /ProcSet [ /PDF /Text /ImageC ]")
    BuildObject(sTempStream,"  /XObject")
    BuildObject(sTempStream,"  <<")
    If UBOUND(arImageID) >= 0 ANDALSO UBOUND(arImageStream) >= 0 Then

       For nIndex = LBOUND(arImageID) To UBOUND(arImageID)

          If arImageID(nIndex).uImage.ImageReferenced = True then

             BuildObject(sTempStream,"    /" + arImageID(nIndex).sImageID +  " " + FORMAT(arImageID(nIndex).uImage.ImageDescriptorObject) + " 0 R ")

          End If

       Next

    End If

    BuildObject(sTempStream,"  >>")
    BuildObject(sTempStream,"  /Font")
    BuildObject(sTempStream,"  <<")

    For nIndex = LBOUND(arFontID) To UBOUND(arFontID)

        sFontID = arFontID(nIndex).sFontID

        If arFontID(nIndex).uFont.FontReferenced = 1 Then

           BuildObject(sTempStream,"    /" + sFontID +  " " + FORMAT(arFontID(nIndex).uFont.FontObject) + " 0 R ")

        End If

    Next

    BuildObject(sTempStream,"  >>")

' End of Procedure Set

    BuildObject(sTempStream,">>")
    BuildObject(sTempStream,"endobj")
    SaveOffset(Len(sTempStream))
    sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
    memcpy(STRPTR(sPDFStream)  + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))

' Create Page Objects

     For nIndex = 1 to UBOUND(arCanvas) + 1

        GetCanvas(nIndex - 1,uCanvas)

        sTempStream = ""

        BuildObject(sTempStream,FORMAT(uCanvas.ObjectNumber) + " 0 obj")
        BuildObject(sTempStream,"<<")
        BuildObject(sTempStream,"/Contents " + FORMAT(uCanvas.StreamObject) + " 0 R")
        BuildObject(sTempStream,"/MediaBox [ 0 0 " + FormatPoint(uCanvas.Width) + " " & FormatPoint(uCanvas.Height) + "]")
        BuildObject(sTempStream,"/Parent " + FORMAT(nPageTreeObject) + " 0 R")
        BuildObject(sTempStream,"/Resources " + FORMAT(nProcSetObject) + " 0 R")
        BuildObject(sTempStream,"/Type /Page")
        BuildObject(sTempStream,">>")
        BuildObject(sTempStream,"endobj")
        SaveOffset(Len(sTempStream))
        sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
        memcpy(STRPTR(sPDFStream)  + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))

     Next

' If outlines are defined link objects together

     If UBOUND(arSection) >=0 Then
        nCurrentObjectNumber = nCurrentObjectNumber + 1
        nRootOutlineObject = nCurrentObjectNumber

        For nIndex = LBOUND(arSection) to UBOUND(arSection)

           arSection(nIndex).StreamID = arCanvas(arSection(nIndex).arCanvasIndex).ObjectNumber
           nCurrentObjectNumber = nCurrentObjectNumber + 1
           arSection(nIndex).ObjectID = nCurrentObjectNumber
           arSection(nIndex).ParentID = nRootOutlineObject

           If nIndex > LBOUND(arSection) Then
              arSection(nIndex).PreviousID = nIndex - 1
           End If

           If nIndex < UBOUND(arSection) ANDALSO LBOUND(arSection) <> UBOUND(arSection) Then
              arSection(nIndex).NextID = nIndex + 1
           End If

        Next

        sTempStream = ""
        BuildObject(sTempStream,FORMAT(nRootOutlineObject) + " 0 obj")
        BuildObject(sTempStream,"<<")
        BuildObject(sTempStream,"/Type /Outlines")
        BuildObject(sTempStream,"/First " + FORMAT(arSection(LBOUND(arSection)).ObjectID) + " 0 R")
        BuildObject(sTempStream,"/Last " + FORMAT(arSection(UBOUND(arSection)).ObjectID) + " 0 R")
        BuildObject(sTempStream,"/Count " + FORMAT(UBOUND(arSection) + 1 + UBOUND(arSubsection) + 1))
        BuildObject(sTempStream,">>")
        BuildObject(sTempStream,"endobj")
        SaveOffset(Len(sTempStream))
        sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
        memcpy(STRPTR(sPDFStream) + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))
        sTempStream = ""

      End If

      If UBOUND(arSubSection) >= 0 Then

         For nIndex = LBOUND(arSubSection) to UBOUND(arSubSection)

             arSubSection(nIndex).ParentID = arSection(arSubSection(nIndex).SectionIndex).ObjectID
             arSubSection(nIndex).StreamID = arCanvas(arSubSection(nIndex).arCanvasIndex).ObjectNumber
             nCurrentObjectNumber = nCurrentObjectNumber + 1
             arSubSection(nIndex).ObjectID = nCurrentObjectNumber
             
             If nIndex = LBOUND(arSubSection) Then

                 arSection(arSubSection(nIndex).SectionIndex).FirstID = arSubSection(nIndex).ObjectID

             End If

              arSection(arSubSection(nIndex).SectionIndex).LastID = arSubSection(nIndex).ObjectID
              arSection(arSubSection(nIndex).SectionIndex).Count = arSection(arSubSection(nIndex).SectionIndex).Count + 1

          Next

      End If

' If there are multiple subsections, link them together

      If UBOUND(arSubSection) > 0 Then

         For nIndex = LBOUND(arSubSection) to UBOUND(arSubSection)

            If nIndex < UBOUND(arSubSection) Then

               arSubSection(nIndex).NextID = arSubSection(nIndex + 1).ObjectID

            End If

            If nIndex > LBOUND(arSubSection) Then

               arSubSection(nIndex).PreviousID = arSubSection(nIndex - 1).ObjectID

            End If

         Next

      End If

      For nIndex = LBOUND(arSection) to UBOUND(arSection)
          sOutLine = GetStringID(arSection(nIndex).STRINGID)
          StringReplace(sOutline,"\","\\")
          StringReplace(sOutline,"\\","\\\\")
          StringReplace(sOutline,"(","\(")
          StringReplace(sOutline,")","\)")
          sOutline = "(" + sOutline + ")"
          BuildObject(sTempStream,FORMAT(arSection(nIndex).ObjectID) + " 0 obj")
          BuildObject(sTempStream,"<<")

          If nIndex = LBOUND(arSection) Then
             BuildObject(sTempStream,"/Title " + sOutline)
             BuildObject(sTempStream,"/Parent " + FORMAT(arSection(nIndex).ParentID) + " 0 R")

          Else

             BuildObject(sTempStream,"/Title " + sOutline)
             BuildObject(sTempStream,"/Parent " + FORMAT(arSection(nIndex).ParentID) + " 0 R")
             BuildObject(sTempStream,"/Prev " + FORMAT(arSection(nIndex - 1).ObjectID) + " 0 R")

          End If

          If nIndex < UBOUND(arSection) Then
             BuildObject(sTempStream,"/Next " + FORMAT(arSection(nIndex + 1).ObjectID) + " 0 R")
          End If

          If arSection(nIndex).FirstID <> 0 Then

             BuildObject(sTempStream,"/First " + FORMAT(arSection(nIndex).FirstID) + " 0 R")
             BuildObject(sTempStream,"/Last " + FORMAT(arSection(nIndex).LastID) + " 0 R")
             If arSection(nIndex).Count > 0 Then
                BuildObject(sTempStream,"/Count " + FORMAT(arSection(nIndex).Count))
             End If

          End If

          BuildObject(sTempStream,"/Dest [" + FORMAT(arSection(nIndex).StreamID) + " 0 R" + " /XYZ null null null]")
          BuildObject(sTempStream,">>")
          BuildObject(sTempStream,"endobj")
          SaveOffset(Len(sTempStream))
          sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
          memcpy(STRPTR(sPDFStream) + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))
          sTempStream = ""

      Next
      
      sTempStream = ""
        
      If UBOUND(arSubSection) >= 0 Then

         For nIndex = LBOUND(arSubSection) to UBOUND(arSubSection)

          sOutLine = GetStringID(arSubSection(nIndex).STRINGID)
          StringReplace(sOutline,"\","\\")
          StringReplace(sOutline,"\\","\\\\")
          StringReplace(sOutline,"(","\(")
          StringReplace(sOutline,")","\)")
          sOutline = "(" + sOutline + ")"
          BuildObject(sTempStream,FORMAT(arSubSection(nIndex).ObjectID) + " 0 obj")
          BuildObject(sTempStream,"<<") 
          BuildObject(sTempStream,"/Title " + sOutline)
          BuildObject(sTempStream,"/Parent " + FORMAT(arSubSection(nIndex).ParentID) + " 0 R")
          If arSubSection(nIndex).NextID <> 0 Then
             BuildObject(sTempStream,"/Next " + FORMAT(arSubSection(nIndex).NextID) + " 0 R")
          End If
          If arSubSection(nIndex).PreviousID <> 0 Then
             BuildObject(sTempStream,"/Prev " + FORMAT(arSubSection(nIndex).PreviousID) + " 0 R")
          End If
          BuildObject(sTempStream,"/Dest [" + FORMAT(arSubSection(nIndex).StreamID) + " 0 R" + " /XYZ null null null]")   
          BuildObject(sTempStream,">>")
          BuildObject(sTempStream,"endobj")
          SaveOffset(Len(sTempStream))
          sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
          memcpy(STRPTR(sPDFStream) + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))
          sTempStream = ""   
             
        Next
        
      End If            

' Create Catalog Object

    nCurrentObjectNumber = nCurrentObjectNumber + 1
    nCatalogObject = nCurrentObjectNumber
    sTempStream = ""

    BuildObject(sTempStream,FORMAT(nCurrentObjectNumber) + " 0 obj")
    BuildObject(sTempStream,"<<")
    BuildObject(sTempStream,"/Type /Catalog")
    BuildObject(sTempStream,"/Pages " + FORMAT(nPageTreeObject) + " 0 R")
    BuildObject(sTempStream,"/PickTrayByPDFSize true")

    If LBOUND(arSection) >= 0 Then

       BuildObject(sTempStream,"/Outlines " + FORMAT(nRootOutlineObject) + " 0 R")
       BuildObject(sTempStream,"/PageMode /UseOutlines")

    End If

     If nPDF_ZOOM <> PDF_ZOOM_NONE Then

        sTempStream = sTempStream + "/OpenAction [2 0 R /"

        If nPDF_ZOOM = PDF_ZOOM_FULLPAGE Then
           BuildObject(sTempStream,"Fit]")
        Else
           If nPDF_ZOOM = PDF_ZOOM_FULLWIDTH Then
              BuildObject(sTempStream,"FitH null]")
           Else
              BuildObject(sTempStream,"XYZ null null 1]")
           End If
       End If

     End If

     If nPDF_LAYOUT <> PDF_LAYOUT_NONE Then

        sTempStream = sTempStream + "/PageLayout /"

        If nPDF_LAYOUT = PDF_LAYOUT_SINGLE Then
           BuildObject(sTempStream,"SinglePage")
        Else
           If nPDF_LAYOUT = PDF_LAYOUT_CONTINUOUS Then
              BuildObject(sTempStream,"OneColumn")
           Else
              BuildObject(sTempStream,"TwoColumnLeft")
           End If
        End If

    End If

' Outline view has priority over thumbnails

   If nPDF_VIEWER_USE_THUMBNAILS = PDF_VIEWER_USE_THUMBNAILS ANDALSO LBOUND(arSection) < 0 Then
      BuildObject(sTempStream,"/PageMode /UseThumbs")
    End If

    If nPDF_VIEWER_HIDEMENUBAR = PDF_VIEWER_HIDEMENUBAR Then
       BuildObject(sTempStream,"/HideMenubar true")
    End If

    If nPDF_VIEWER_HIDETOOLBAR = PDF_VIEWER_HIDETOOLBAR Then
       BuildObject(sTempStream,"/HideToolbar true")
    End If

    If nPDF_VIEWER_SHOWTITLE = PDF_VIEWER_SHOWTITLE Then
       BuildObject(sTempStream,"/DisplayDocTitle true")
    End If

    If nPDF_VIEWER_HIDEWINDOWUI = PDF_VIEWER_HIDEWINDOWUI Then
       BuildObject(sTempStream,"/HideWindowUI true")
    End If

    If nPDF_VIEWER_CENTER_WINDOW = PDF_VIEWER_CENTER_WINDOW Then
       BuildObject(sTempStream,"/CenterWindow true")
    End If

    If nPDF_VIEWER_FIT_WINDOW = PDF_VIEWER_FIT_WINDOW Then
       BuildObject(sTempStream,"/FitWindow true")
    End If

    BuildObject(sTempStream,">>")
    BuildObject(sTempStream,"endobj")

    SaveOffset(Len(sTempStream))
    sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
    memcpy(STRPTR(sPDFStream) + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))
    sTempStream = ""

' Create Cross Reference Table

    nCurrentObjectNumber = nCurrentObjectNumber + 1

    BuildObject(sTempStream,"xref")
    BuildObject(sTempStream,"0 " + FORMAT(nCurrentObjectNumber))
    BuildObject(sTempStream,"0000000000 65535 f")

    For nIndex = 1 To nCurrentObjectNumber - 1

        nObject = VAL(oObjectOffsetList.Item(nIndex))
        BuildObject(sTempStream,FORMAT(nObject,"0000000000") + " 00000 n")

    Next

    sDocumentID = PDFDocumentID()

    BuildObject(sTempStream,"trailer")
    BuildObject(sTempStream,"<<")
    BuildObject(sTempStream,"/Size " + FORMAT(nCurrentObjectNumber))
    BuildObject(sTempStream,"/Root " + FORMAT(nCatalogObject) + " 0 R")
    BuildObject(sTempStream,"/Info 1 0 R")
    BuildObject(sTempStream,"/ID[<" + sDocumentID + "><" + sDocumentID + ">]")
    BuildObject(sTempStream,">>")
    BuildObject(sTempStream,"startxref")
    nIndex = nCurrentObjectNumber
    nOffset = VAL(oObjectOffsetList.Item(nIndex))
    BuildObject(sTempStream,FORMAT(nOffset))
    sPDFStream = sPDFStream + SPACE(LEN(sTempStream))
    memcpy(STRPTR(sPDFStream) + LEN(sPDFStream) - LEN(sTempStream),STRPTR(sTempStream),LEN(sTempStream))
    sPDFStream = sPDFStream + SPACE(LEN(sEOFMarker))
    memcpy(STRPTR(sPDFStream) + LEN(sPDFStream) - LEN(sEOFMarker),STRPTR(sEOFMarker),LEN(sEOFMarker))

' At this point sPDFStream contains the full document
' Check if a document name was provided and save it

   If AfxPathFileExists(sDocument) = False Then

      sLastErrorDescription = "Missing or invalid PDF document path."
      bReturn = False

   Else

      sPDFDocument = sDocument

      hFile = CreateFileW(@sPDFDocument, GENERIC_WRITE, 0, NULL, _
                          CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL OR FILE_FLAG_SEQUENTIAL_SCAN, NULL)
      WriteFile(hFile, STRPTR(sPDFStream), LEN(sPDFSTREAM), @dwBytesWritten, NULL)
      CloseHandle(hFile)

' Check if the PDF document is to be opened by the associated PDF viewer

      If nOpenPDF = 1 Then

          nFindResult = FindExecutableW(@sPDFDocument,BYVAL NULL,@sPDFAssociation)
          If nFindResult > 32 Then

             ShellExecute(BYVAL NULL,"open",@sPDFDocument,BYVAL NULL,BYVAL NULL,SW_SHOWNORMAL)

          End If

      End If

   End If

' Clear objects for possible multiple documents

   ERASE arCanvas
   ERASE arPlaceHolderObject
   ERASE arStringID
   ERASE arImageID
   ERASE arImageStream
   ERASE arSection
   ERASE arSubSection
   ERASE arReportTemplate
   ERASE arReportHeaderTemplate
   ERASE arReportColumnHeaderTemplate
   ERASE arReportColumns
   ERASE arReportHeaderText
   oPageStreamList.Clear
   oObjectOffsetList.Clear
   oImageDescriptor.RemoveAll
   oImageStream.RemoveAll
   nCurrentObjectNumber = 0
   nDefaultFontSize = 12
   nDefaultFontColor = RGB_BLACK
   nPDF_ZOOM = PDF_ZOOM_FULLPAGE
   nPDF_LAYOUT = PDF_LAYOUT_SINGLE
   nCurrentPaperID = PDF_PAPER_LETTER
   nCurrentPaperOrientation = PDFPAGE_PORTRAIT
   nCurrentWidth = 612
   nCurrentHeight = 792 
   nCurrentTopMargin = PDF_ONE_QUARTER_INCH
   nCurrentLeftMargin = PDF_ONE_QUARTER_INCH
   nCurrentBottomMargin = PDF_ONE_QUARTER_INCH
   nCurrentRightMargin = PDF_ONE_QUARTER_INCH
   nPageCharacterSpacing = ITEM_IGNORE
   nPageWordSpacing = ITEM_IGNORE
   nPageHorizontalScaling = 100
   nPageTextLeading = ITEM_IGNORE
   nPageRenderingMode = TEXTRENDERING_FILL
   nNextStringID = 1
   nPDF_VIEWER_USE_THUMBNAILS = 0
   nPDF_VIEWER_HIDEMENUBAR = 0
   nPDF_VIEWER_HIDETOOLBAR = 0
   nPDF_VIEWER_SHOWTITLE = 0
   nPDF_VIEWER_HIDEWINDOWUI = 0
   nPDF_VIEWER_CENTER_WINDOW = 0
   nPDF_VIEWER_FIT_WINDOW = 0
   nTotalFonts = 0
   sPDFStream = ""
   sTempStream = ""
   sAuthor = ""
   sCreator = ""
   sSubject= ""
   sTitle = ""
   sKeywords = ""
   sCurrentPaperName = "Letter"
   sLastErrorDescription = ""

   For nIndex = LBOUND(arFontID) to UBOUND(arFontID)

      arFontID(nIndex).uFont.FontObject = 0
      arFontID(nIndex).uFont.FontDescriptorObject = 0
      arFontID(nIndex).uFont.FontWidthObject = 0

   Next

   If LBOUND(arFontEmbed) >= 0 Then

      For nIndex = LBOUND(arFontEmbed) to UBOUND(arFontEmbed)

         arFontEmbed(nIndex).nFontObject = 0

      Next

   End If

   RETURN bReturn

End Function

' =====================================================================================
' Close out current page content if necessary
' =====================================================================================

Private SUB cPDF.PDFEndPage()

    EndStream()

End Sub

' =====================================================================================
' Draw a line
' =====================================================================================

Private SUB cPDF.PDFLineAdd (BYVAL nFromX AS DOUBLE, BYVAL nFromY AS DOUBLE, BYVAL nToX AS DOUBLE, _
                             BYVAL nToY AS DOUBLE, BYREF uLine AS LineDescriptor)

   PDFStartLine(nFromX,nFromY,uLine)
   PDFMoveTo(nToX,nToY)
   PDFDrawLine()
   RestoreGraphicsState()

End Sub

' =====================================================================================
' Set the character spacing - stays active for the current page unless changed
' =====================================================================================

Private SUB cPDF.PDFTextSpacing(BYVAL nCharacterSpacing AS DOUBLE)

    If nCharacterSpacing >= 0 Then

       BuildObject(sTempStream,FormatPoint(nCharacterSpacing) + " Tc")

    End If

End Sub

' =====================================================================================
' Set the word spacing - stays active for the current page unless changed
' =====================================================================================

Private SUB cPDF.PDFTextWordSpacing(BYVAL nWordSpacing AS DOUBLE)

    If nWordSpacing >= 0 Then

       BuildObject(sTempStream,FormatPoint(nWordSpacing) + " Tw")

    End If

End Sub

' =====================================================================================
' Set scaling percentage from 1 to ?? - stays active for the current page unless changed
' =====================================================================================

Private SUB cPDF.PDFTextHorizontalScaling(BYVAL nHorizontalScaling AS WORD)

   If nHorizontalScaling >= 1 Then

      BuildObject(sTempStream,Format(nHorizontalScaling) + " Tz")

   End If

End Sub

' =====================================================================================
' Set the text leading - stays active for the current page unless changed
' =====================================================================================

Private SUB cPDF.PDFTextLeading(BYVAL nLeading AS DOUBLE)

    If nLeading >= 0 Then

      BuildObject(sTempStream,FormatPoint(nLeading) + " TL")

    End If

End Sub

' =====================================================================================
' Set the text rendering - stays active for the current page unless changed
' =====================================================================================

Private SUB cPDF.PDFTextRenderingMode(BYVAL nRendering AS LONG)

    If nRendering >= TEXTRENDERING_FILL AndAlso nRendering <= TEXTRENDERING_ADDCLIPPING Then

       BuildObject(sTempStream,FORMAT(nRendering) + " Tr")

    End If

End Sub

' =====================================================================================
' Set the text rise, useful for sub/super scripting
' Stays active for the current page unless changed
' =====================================================================================

Private SUB cPDF.PDFTextRise(BYVAL nRise AS DOUBLE)

    BuildObject(sTempStream,FormatPoint(nRise) + " Ts")

End Sub

Private SUB cPDF.PDFInsertPlaceHolders()

DIM nIndex    AS LONG

    If UBOUND( arPlaceHolderObject) >= 0 Then

       For nIndex = LBOUND(arPlaceHolderObject) to UBOUND(arPlaceHolderObject)

           BuildObject(sTempStream,arPlaceHolderObject(nIndex).ID)

       Next

    End If

End Sub

' =====================================================================================
' Begin the stream object for current page content
' =====================================================================================

Private SUB cPDF.StartStream()

DIM uCanvas         AS PageCanvas
DIM nIndex          AS Long


    GetCurrentCanvas(uCanvas)

    uCanvas.StreamComplete = False
    UpdateCurrentCanvas(uCanvas)

    sTempStream = ""

' Set the page wide text metrics

    PDFTextSpacing(nPageCharacterSpacing)
    PDFTextWordSpacing(nPageWordSpacing)
    PDFTextHorizontalScaling(nPageHorizontalScaling)
    PDFTextLeading(nPageTextLeading)
    PDFTextRenderingMode(nPageRenderingMode)
    PDFTextRise(0)

' Insert any PlaceHolders

    If UBOUND(arCanvas) > 0 Then

       PDFInsertPlaceHolders()

    End If

End Sub

' =====================================================================================
' Retrieve stored image attributes
' =====================================================================================

Private FUNCTION cPDF.PDFImageAttributes(BYREF sImageID AS DWSTRING, BYREF uImageAttributes AS ImageAttributes) AS BOOLEAN

DIM bResult     AS BOOLEAN = False
DIM nIndex      AS LONG

   sLastErrorDescription = ""

   If UBOUND(arImageID) >=0 Then

      For nIndex = LBOUND(arImageID) to UBOUND(arImageID)

         If sImageID = arImageID(nIndex).sImageID Then
            uImageAttributes = arImageID(nIndex).uImage
            bResult = True
            EXIT FOR
         End If

      Next

   End If

   If bResult = False then

      sLastErrorDescription = "Image ID " + sImageID + " not found."

   End If

   RETURN bResult

End Function

' =====================================================================================
' Draw an ellispe centered at nX, nY
' =====================================================================================

Private SUB cPDF.PDFEllispe(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, BYVAL nHeight AS DOUBLE, _
                            BYVAL nWidth AS DOUBLE, BYVAL nOutlineColor AS LONG, BYVAL nFillColor AS LONG)

DIM uCanvas           AS PageCanvas
DIM nXRadius          AS DOUBLE
DIM nYRadius          AS DOUBLE
DIM nStartX           AS DOUBLE
DIM nStartY           AS DOUBLE
DIM nX1Control        AS DOUBLE
DIM nY1Control        AS DOUBLE
DIM nX2Control        AS DOUBLE
DIM nY2Control        AS DOUBLE
DIM nXEnd             AS DOUBLE
DIM nYEnd             AS DOUBLE
DIM nXBezier          AS DOUBLE
DIM nYBezier          AS DOUBLE

    GetCurrentCanvas(uCanvas)

    SaveGraphicsState()

    nFillColor = IIF(nFillColor >= 0,nFillColor,0)
    SetNonStrokingColor(nFillColor)

    SetStrokingColor(nOutlineColor)

    nYRadius = nHeight / 2
    nXRadius = nWidth / 2
    nXBezier = nXRadius * nBezierMagic
    nYBezier = nYRadius * nBezierMagic

' Start the drawing from the top midpoint

    nY = nY - nYRadius
    nStartX = nX
    nStartY = nY

' Set the current point

    DrawingPoints(uCanvas,nX,nY)
    BuildObject(sTempStream,FormatPoint(nX) + " " + _
                            FormatPoint(nY) + " m")

' Draw the ellispe counterclock wise

    nX1Control = nStartX - nXBezier
    nY1Control = nStartY
    nXEnd = nStartX - nXRadius
    nYEnd = nStartY + nYRadius
    nX2Control = nXEnd
    nY2Control = nYEnd - nYBezier

    PDFCurve(nX1Control,nY1Control,nX2Control,nY2Control,nXEnd,nYEnd)

    nStartX = nXEnd
    nStartY = nYEnd

    nX1Control = nStartX
    nY1Control = nStartY + nYBezier
    nXEnd = nStartX + nXRadius
    nYEnd = nStartY + nYRadius
    nX2Control = nXEnd - nXBezier
    nY2Control = nYEnd

    PDFCurve(nX1Control,nY1Control,nX2Control,nY2Control,nXEnd,nYEnd)

    nStartX = nXEnd
    nStartY = nYEnd

    nX1Control = nStartX + nXBezier
    nY1Control = nStartY
    nXEnd = nStartX + nXRadius
    nYEnd = nStartY - nYRadius
    nX2Control = nXEnd
    nY2Control = nYEnd + nYBezier

    PDFCurve(nX1Control,nY1Control,nX2Control,nY2Control,nXEnd,nYEnd)

    nStartX = nXEnd
    nStartY = nYEnd

    nX1Control = nStartX
    nY1Control = nStartY - nYBezier
    nXEnd = nStartX - nXRadius
    nYEnd = nStartY - nYRadius
    nX2Control = nXEnd + nXBezier
    nY2Control = nYEnd

    PDFCurve(nX1Control,nY1Control,nX2Control,nY2Control,nXEnd,nYEnd)

    BuildObject(sTempStream,"B")

    RestoreGraphicsState()

End Sub

' =====================================================================================
' Draw a regular polygon with equal sides and angles
' =====================================================================================

Private SUB cPDF.PDFRegularPolygon(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, ByVal nRadius AS DOUBLE, _
                                   BYVAL nSides AS LONG, BYVAL nFillColor AS LONG, BYREF uLine AS LineDescriptor)

DIM nAngle         AS DOUBLE
DIM nStartX        AS DOUBLE
DIM nStartY        AS DOUBLE
DIM nRadians       AS DOUBLE
DIM nIndex         AS LONG

' Must have at least 3 sides

   If nSides >=3 Then

      nAngle = (360 / nSides) / 2
      nRadians = PI * nAngle / 180
      nStartX = nRadius * COS(nRadians) + nX
      nStartY = nRadius * SIN(nRadians) + nY

      PDFStartLine(nStartX,nStartY,uLine)

      For nIndex = 2 To nSides

         nAngle = nAngle + 360 / nSides
         nRadians = PI * nAngle / 180
         PDFMoveTo(nRadius * Cos(nRadians) + nX,nRadius * Sin(nRadians) + nY)
      Next

      PDFMoveTo(nStartX,nStartY)

      If nFillColor <> ITEM_IGNORE Then

         SetNonStrokingColor(nFillColor)
         PDFPathFillAndStroke(1)

      Else

         PDFDrawLine()

      End If

      RestoreGraphicsState()

   End If

End Sub

Private FUNCTION cPDF.PDFEmbedFont(BYVAL nFontFamily AS LONG, BYVAL nFontStyle AS LONG, BYVAL sFontFile AS DWSTRING) AS BOOLEAN

DIM bResult            AS BOOLEAN = False
DIM sFontID            AS DWSTRING = ""
DIM nIndex             AS LONG
DIM uPDFFontEmbed      AS PDFFontEmbed
DIM oCFileSys          AS CFileSys
DIM sUnCompressedFont  AS STRING
DIM hFile              AS HANDLE
DIM dwBytesRead        AS DWORD
DIM szFontFile         AS WSTRING * MAX_PATH
DIM sFileType          AS DWSTRING

   sLastErrorDescription = ""
   szFontFile = sFontFile

' Find Supported Font ID

   For nIndex = LBOUND(arFontID) to UBOUND(arFontID)

      If arFontID(nIndex).uFont.FontID = nFontFamily ANDALSO arFontID(nIndex).uFont.FontStyle = nFontStyle Then

         sFontID = arFontID(nIndex).sFontID
         bResult = True
         EXIT FOR

      End If

   Next

' Check for error exceptions

   If bResult = False Then

      sLastErrorDescription = "Font Family/Style not supported."

   Else

       bResult = oCFileSys.FileExists(sFontFile)
       If bResult = False Then

          sLastErrorDescription = "Font file not found."

       Else

         sFileType = oCFileSys.GetFileType(sFontFile)

         If sFileType = "TrueType font file" ORELSE sFileType = "TTF File" Then

         Else

            bResult = False
            sLastErrorDescription = "Not a True Type Font file."

         End If
       
       End If

   End If

   If bResult = True Then

' Save True Type file

      uPDFFontEmbed.sFontID = sFontID
      uPDFFontEmbed.nUncompressedSize = oCFileSys.GetFileSize(sFontFile)

' Get Contents of True Type File

      sUnCompressedFont = SPACE(uPDFFontEmbed.nUncompressedSize)
      hFile = CreateFileW(@szFontFile, GENERIC_READ, FILE_SHARE_READ, NULL, _
                          OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL)
      ReadFile(hFile,STRPTR(sUnCompressedFont),uPDFFontEmbed.nUncompressedSize, @dwBytesRead, NULL)
      CloseHandle(hFile)

' Compress if ZLib available

      If hZlib <> 0 Then

         bResult = PDFFlateCompress(sUnCompressedFont,uPDFFontEmbed.sCompressedFont)
         If bResult = True Then

            uPDFFontEmbed.nCompressedSize = LEN(uPDFFontEmbed.sCompressedFont)

         Else

            uPDFFontEmbed.sCompressedFont = sUnCompressedFont
            uPDFFontEmbed.nCompressedSize = uPDFFontEmbed.nUncompressedSize

            bResult = True

         End If

      Else

         uPDFFontEmbed.sCompressedFont = sUnCompressedFont
         uPDFFontEmbed.nCompressedSize = uPDFFontEmbed.nUncompressedSize

      End If

      arFontID(nIndex).uFont.FontStandard = 0
      AppendElementToArray(arFontEmbed,uPDFFontEmbed)

   End If

   RETURN bResult

End Function

' =====================================================================================
' Create a report template
' =====================================================================================

Private FUNCTION cPDF.PDFCreateReportTemplate(BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                              BYVAL nJustify AS LONG, BYREF uMargins AS RECT, uRectangle AS RectangleDescriptor) AS DWSTRING

DIM uReportTemplate   AS ReportTemplate

    uReportTemplate.TemplateID = "T" + FORMAT(UBOUND(arReportTemplate) + 1)
    uReportTemplate.X = nX + ABS(uMargins.Left)
    uReportTemplate.Y = nY + ABS(uMargins.Top)
    uReportTemplate.Rectangle = uRectangle
    uReportTemplate.Rectangle.Height = uReportTemplate.Rectangle.Height - ABS(uMargins.Top) - ABS(uMargins.Bottom)
    uReportTemplate.Rectangle.Width = uReportTemplate.Rectangle.Width - ABS(uMargins.Left) - ABS(uMargins.Right)
    uReportTemplate.Margins = uMargins
    uReportTemplate.Justify = nJustify
    AppendElementToArray(arReportTemplate,uReportTemplate)

    RETURN uReportTemplate.TemplateID

End Function

' =====================================================================================
' Create a report header template
' =====================================================================================

Private FUNCTION cPDF.PDFCreateReportHeaderTemplate(BYREF sTemplateID AS DWSTRING, BYREF uMargins AS RECT, uRectangle AS RectangleDescriptor) AS BOOLEAN

DIM bFound                 AS BOOLEAN = False
DIM nIndex                 AS LONG
DIM nMainWidth             AS LONG
DIM uReportHeaderTemplate  AS ReportHeaderTemplate

   sLastErrorDescription = ""

' Validate sTemplateID

   If UBOUND(arReportTemplate) >=0 Then

      For nIndex = LBOUND(arReportTemplate) to UBOUND(arReportTemplate)

         If arReportTemplate(nIndex).TemplateID = sTemplateID Then

            nMainWidth = arReportTemplate(nIndex).Rectangle.Width
            bFound = True
            EXIT FOR

         End If

      Next

   End If

' If main template not found sTemplateID is invalid

   If bFound = False then

      sLastErrorDescription = "Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End IF

   bFound = False   

' Ensure only one header is defined

   If UBOUND(arReportHeaderTemplate) >=0 Then

      For nIndex = LBOUND(arReportHeaderTemplate) to UBOUND(arReportHeaderTemplate)

         If arReportHeaderTemplate(nIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

   If bFound = True Then

      sLastErrorDescription = "Report Header already defined."
      RETURN False
      EXIT FUNCTION

   End If

   uReportHeaderTemplate.TemplateID = sTemplateID
   uReportHeaderTemplate.Margins = uMargins
   uReportHeaderTemplate.Rectangle = uRectangle
   uReportHeaderTemplate.Rectangle.Width = nMainWidth
   uReportHeaderTemplate.Rectangle.Height = uReportHeaderTemplate.Rectangle.Height _
                                          + uMargins.Top + uMargins.Bottom
   AppendElementToArray(arReportHeaderTemplate,uReportHeaderTemplate)

   RETURN True    

End Function

' =====================================================================================
' Add text to report header
' =====================================================================================

Private FUNCTION cPDF.PDFAddHeaderText(BYREF sTemplateID AS DWSTRING, BYVAL nX AS DOUBLE, BYVAL nY AS DOUBLE, _
                                       BYREF uText AS TextDescriptor, BYVAL sHeaderText AS DWSTRING) AS BOOLEAN

DIM bFound              AS BOOLEAN = False
DIM nIndex              AS LONG
DIM uReportHeaderText   AS ReportHeaderText

   sLastErrorDescription = ""

' Validate sTemplateID

   If UBOUND(arReportTemplate) >=0 Then

      For nIndex = LBOUND(arReportTemplate) to UBOUND(arReportTemplate)

         If arReportTemplate(nIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

' If main template not found sTemplateID is invalid

   If bFound = False then

      sLastErrorDescription = "Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

   bFound = False

' Check that a header is defined

   If UBOUND(arReportColumnHeaderTemplate) >=0 Then

      For nIndex = LBOUND(arReportColumnHeaderTemplate) to UBOUND(arReportColumnHeaderTemplate)

         If arReportColumnHeaderTemplate(nIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

' Check for a defined report header

   If bFound = False then

      sLastErrorDescription = " Report Header for Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End IF

   uReportHeaderText.TemplateID = sTemplateID
   uReportHeaderText.StringID = CreateStringID(sHeaderText)
   uReportHeaderText.X = nX
   uReportHeaderText.Y = nY
   uReportHeaderText.TextDescriptor = uText
   AppendElementToArray(arReportHeaderText,uReportHeaderText)

   RETURN True

End Function

' =====================================================================================
' Create a report column header template
' =====================================================================================

Private FUNCTION cPDF.PDFCreateReportColumnHeaderTemplate(BYREF sTemplateID AS DWSTRING, BYREF uMargins AS RECT, uRectangle AS RectangleDescriptor) AS BOOLEAN

DIM bFound                       AS BOOLEAN = False
DIM nIndex                       AS LONG
DIM nMainWidth                   AS LONG
DIM uReportHeaderColumnTemplate  AS ReportColumnHeaderTemplate

   sLastErrorDescription = ""

' Validate sTemplateID

   If UBOUND(arReportTemplate) >=0 Then

      For nIndex = LBOUND(arReportTemplate) to UBOUND(arReportTemplate)

         If arReportTemplate(nIndex).TemplateID = sTemplateID Then

            nMainWidth = arReportTemplate(nIndex).Rectangle.Width
            bFound = True
            EXIT FOR

         End If

      Next

   End If

' If main template not found sTemplateID is invalid

   If bFound = False then

      sLastErrorDescription = "Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

   bFound = False   

' Ensure only one header is defined

   If UBOUND(arReportColumnHeaderTemplate) >=0 Then

      For nIndex = LBOUND(arReportColumnHeaderTemplate) to UBOUND(arReportColumnHeaderTemplate)

         If arReportColumnHeaderTemplate(nIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

   If bFound = True Then

      sLastErrorDescription = "Column Header for Template ID " + sTemplateID + " already defined."
      RETURN False
      EXIT FUNCTION

   End If

   uReportHeaderColumnTemplate.TemplateID = sTemplateID
   uReportHeaderColumnTemplate.Margins = uMargins
   uReportHeaderColumnTemplate.Rectangle = uRectangle
   uReportHeaderColumnTemplate.Rectangle.Height = uReportHeaderColumnTemplate.Rectangle.Height _
                                                + uMargins.Top + uMargins.Bottom
   uReportHeaderColumnTemplate.Rectangle.Width = nMainWidth
   AppendElementToArray(arReportColumnHeaderTemplate,uReportHeaderColumnTemplate)

   RETURN True 

End Function

' =====================================================================================
' Add a report column
' =====================================================================================

Private FUNCTION cPDF.PDFAddReportColumns(BYREF sTemplateID AS DWSTRING, BYREF uMargins AS RECT, BYVAL sString AS DWSTRING, uRectangle AS RectangleDescriptor, _
                                          BYREF uText AS TextDescriptor, BYVAL nVerticalAlignment AS LONG, _
                                          BYVAL nOddLineFillColor AS LONG, BYVAL nEvenLineFillColor AS LONG) AS BOOLEAN

DIM bFound              AS BOOLEAN = False
DIM nIndex              AS LONG
DIM nMainWidth          AS LONG
DIM nTotalWidths        AS LONG = 0
DIM uReportColumns      AS ReportColumns

  sLastErrorDescription = ""

' Validate sTemplateID

   If UBOUND(arReportTemplate) >=0 Then

      For nIndex = LBOUND(arReportTemplate) to UBOUND(arReportTemplate)

         If arReportTemplate(nIndex).TemplateID = sTemplateID Then

            nMainWidth = arReportTemplate(nIndex).Rectangle.Width
            bFound = True
            EXIT FOR

         End If

      Next

   End If

' If main template not found sTemplateID is invalid

   If bFound = False then

      sLastErrorDescription = "Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

' Sum up previous column widths

   If UBOUND(arReportColumns) >= 0 Then

      For nIndex = LBOUND(arReportColumns) to UBOUND(arReportColumns)

         If arReportColumns(nIndex).TemplateID = sTemplateID Then

            nTotalWidths = nTotalWidths + arReportColumns(nIndex).Rectangle.Width

         End If

      Next

   End If

' Check if column will fit

   If nTotalWidths + uRectangle.Width > nMainWidth Then

      sLastErrorDescription = "Total Column Widths for Template ID " + sTemplateID + " exceeds available width."
      RETURN False
      EXIT FUNCTION

   End If

   uReportColumns.TemplateID = sTemplateID
   uReportColumns.StringID = CreateStringID(sString)
   uReportColumns.Margins = uMargins
   uReportColumns.Rectangle = uRectangle
   uReportColumns.TotalWidth = nTotalWidths
   uReportColumns.TextDescriptor = uText
   uReportColumns.OddLineFillColor = nOddLineFillColor
   uReportColumns.EvenLineFillColor = nEvenLineFillColor

   Select CASE nVerticalAlignment

          CASE TEXT_VERTICAL_TOP, TEXT_VERTICAL_CENTER, TEXT_VERTICAL_BOTTOM

            uReportColumns.VerticalAlignment = nVerticalAlignment

          CASE Else

             uReportColumns.VerticalAlignment = ITEM_IGNORE

   End Select

   AppendElementToArray(arReportColumns,uReportColumns)

   RETURN True 

End Function

' =====================================================================================
' Draw a report template
' =====================================================================================

Private FUNCTION cPDF.PDFDrawReportTemplate(BYREF sTemplateID AS DWSTRING) AS BOOLEAN

DIM bFound              AS BOOLEAN = False
DIM nIndex              AS LONG
DIM nHeaderIndex        AS LONG = -1
DIM nColumnHeaderIndex  AS LONG = -1
DIM nColumnsIndex       AS LONG = -1
DIM uMetrics            AS PageMetrics
DIM nX                  AS LONG
DIM nY                  AS LONG
DIM sColumnText         AS DWSTRING
DIM nXColumnText        AS LONG
DIM nYColumnText        AS LONG
DIM uMulti              AS MultiLineTextDescriptor
DIM nLineHeight         AS LONG
DIM nHeaderTextIndex    AS LONG

   sLastErrorDescription = ""

' Validate sTemplateID

   If UBOUND(arReportTemplate) >=0 Then

      For nIndex = LBOUND(arReportTemplate) to UBOUND(arReportTemplate)

         If arReportTemplate(nIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

   If bFound = False Then

      sLastErrorDescription = "Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

   PDFCurrentPageMetrics(uMetrics)

' Draw the main report canvas area

   Select CASE arReportTemplate(nIndex).Justify

      CASE TEXT_JUSTIFY_LEFT

         arReportTemplate(nIndex).X = uMetrics.LeftMargin + ABS(arReportTemplate(nIndex).Margins.Left)

      CASE TEXT_JUSTIFY_RIGHT


      arReportTemplate(nIndex).X = uMetrics.DrawingWidth _
                                  - ABS(arReportTemplate(nIndex).Margins.Right) _
                                  - arReportTemplate(nIndex).Rectangle.Width

      CASE TEXT_JUSTIFY_CENTER
      
         arReportTemplate(nIndex).X = (uMetrics.DrawingWidth / 2) - (arReportTemplate(nIndex).Rectangle.Width / 2)

   End Select

   PDFRectangle(arReportTemplate(nIndex).X,arReportTemplate(nIndex).Y,arReportTemplate(nIndex).Rectangle)

' Draw Header if available

   bFound = False

   If UBOUND(arReportHeaderTemplate) >=0 Then

      For nHeaderIndex = LBOUND(arReportHeaderTemplate) to UBOUND(arReportHeaderTemplate)

         If arReportHeaderTemplate(nHeaderIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

   If bFound = True Then

      PDFRectangle(arReportTemplate(nIndex).X,arReportTemplate(nIndex).Y,arReportHeaderTemplate(nHeaderIndex).Rectangle)

' Check for any Header Text to add

      If UBOUND(arReportHeaderText) >= 0 Then

         For nHeaderTextIndex = LBOUND(arReportHeaderText) TO UBOUND(arReportHeaderText)

            If arReportHeaderText(nHeaderTextIndex).TemplateID = sTemplateID Then

               uMulti.Height = arReportHeaderTemplate(nHeaderIndex).Rectangle.Height - arReportHeaderTemplate(nHeaderIndex).Margins.top
               uMulti.Width = arReportHeaderTemplate(nHeaderIndex).Rectangle.Width _
                            - arReportHeaderTemplate(nHeaderIndex).Margins.left _
                            - arReportHeaderTemplate(nHeaderIndex).Margins.Right _
                            + arReportHeaderText(nHeaderTextIndex).Y
               uMulti.VerticalAlignment = ITEM_IGNORE
               uMulti.Spacing = ITEM_IGNORE
               uMulti.TextAttributes = arReportHeaderText(nHeaderTextIndex).TextDescriptor
               PDFMultiLineTextBox(arReportHeaderText(nHeaderIndex).X + arReportTemplate(nIndex).X + _
                                   arReportHeaderTemplate(nHeaderIndex).Margins.top, _
                                   arReportHeaderText(nHeaderIndex).Y + arReportTemplate(nIndex).Y + _
                                   PDFLineHeight(uMulti.TextAttributes.FontID,uMulti.TextAttributes.FontSize), _
                                   uMulti,GetStringID(arReportHeaderText(nHeaderTextIndex).StringID))

            End If

         Next

      End If

   Else

      nHeaderIndex = -1

   End If

' Draw Column Header if available

   bFound = False

   If UBOUND(arReportColumnHeaderTemplate) >=0 Then

      For nColumnHeaderIndex = LBOUND(arReportColumnHeaderTemplate) to UBOUND(arReportColumnHeaderTemplate)

         If arReportColumnHeaderTemplate(nColumnHeaderIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

   If bFound = True Then

      If nHeaderIndex >= 0 Then

         nY = arReportHeaderTemplate(nHeaderIndex).Rectangle.Height

      End If

      PDFRectangle(arReportTemplate(nIndex).X,arReportTemplate(nIndex).Y + nY,arReportColumnHeaderTemplate(nColumnHeaderIndex).Rectangle)

   Else

      nColumnHeaderIndex = -1

   End If

' Column Headers are required as a container

   If nColumnHeaderIndex = -1 Then

      sLastErrorDescription = "Column Header for Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

' Add Columns

   If UBOUND(arReportColumns) >= 0 Then

      For nColumnsIndex = LBOUND(arReportColumns) to  UBOUND(arReportColumns)

         If arReportColumns(nColumnsIndex).TemplateID = sTemplateID Then

            arReportColumns(nColumnsIndex).Rectangle.Height = arReportColumnHeaderTemplate(nColumnHeaderIndex).Rectangle.Height

            PDFRectangle(arReportTemplate(nIndex).X + arReportColumns(nColumnsIndex).TotalWidth,arReportTemplate(nIndex).Y _
                         + nY,arReportColumns(nColumnsIndex).Rectangle)


            sColumnText = GetStringID(arReportColumns(nColumnsIndex).StringID)
            nLineHeight = PDFLineHeight(arReportColumns(nColumnsIndex).TextDescriptor.FontID,arReportColumns(nColumnsIndex).TextDescriptor.FontSize)

            If arReportColumns(nColumnsIndex).TextDescriptor.Underline = FONT_UNDERLINE Then

               arReportColumns(nColumnsIndex).TextDescriptor.LineDescriptor.Color = RGB_BLACK
               arReportColumns(nColumnsIndex).TextDescriptor.LineDescriptor.Cap = PDF_LINECAP_PROJECTING_SQUARE

            End If

            nXColumnText = arReportTemplate(nIndex).X + arReportColumns(nColumnsIndex).TotalWidth _
                         + arReportColumns(nColumnsIndex).Margins.left
            nYColumnText = arReportTemplate(nIndex).Y + nY _
                         +  arReportColumns(nColumnsIndex).Margins.top _
                         + nLineHeight

            uMulti.Width = arReportColumns(nColumnsIndex).Rectangle.Width _
                         -  arReportColumns(nColumnsIndex).Margins.left _
                         -  arReportColumns(nColumnsIndex).Margins.right
            uMulti.Height = arReportColumns(nColumnsIndex).Rectangle.Height _
                          -  arReportColumns(nColumnsIndex).Margins.top _
                          - arReportColumns(nColumnsIndex).Margins.bottom
            uMulti.VerticalAlignment = arReportColumns(nColumnsIndex).VerticalAlignment
            uMulti.TextAttributes = arReportColumns(nColumnsIndex).TextDescriptor
            PDFMultiLineTextBox(nXColumnText,nYColumnText,uMulti,sColumnText)

         End If

      Next

   End If

   RETURN True

End Function

' =====================================================================================
' Draw Report Rows
' =====================================================================================

Private FUNCTION cPDF.PDFDrawRows(BYREF sTemplateID AS DWSTRING, arRows() AS ReportRow) AS BOOLEAN

DIM bFound                   AS BOOLEAN = False
DIM nIndex                   AS LONG
DIM nHeaderIndex             AS LONG = -1
DIM nColumnHeaderIndex       AS LONG = -1
DIM nColumnsIndex            AS LONG = -1
DIM nRowIndex                AS LONG
DIM nY                       AS LONG
DIM nRowY                    AS LONG
DIM arColumns()              AS ReportColumns
DIM uRowRectangle            AS RectangleDescriptor
DIM uRowColumnRectangle      AS RectangleDescriptor
DIM sColumnText              AS DWSTRING
DIM nXColumnText             AS LONG
DIM nYColumnText             AS LONG
DIM uMulti                   AS MultiLineTextDescriptor
DIM nLineHeight              AS LONG
DIM nReportHeight            AS LONG
DIM nReportRemainingHeight   AS LONG
DIM nRowNumber               AS LONG

   sLastErrorDescription = ""

' Check that rows are provided

   If UBOUND(arRows) < 0 Then

      sLastErrorDescription = "No rows provided for Template ID " + sTemplateID + "."
      RETURN False
      EXIT FUNCTION

   End If

' Validate sTemplateID

   If UBOUND(arReportTemplate) >=0 Then

      For nIndex = LBOUND(arReportTemplate) to UBOUND(arReportTemplate)

         If arReportTemplate(nIndex).TemplateID = sTemplateID Then

            bFound = True
            EXIT FOR

         End If

      Next

   End If

   If bFound = False Then

      sLastErrorDescription = "Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

' Draw Report Template

   If PDFDrawReportTemplate(sTemplateID) = False Then

      RETURN False
      EXIT FUNCTION
 
   End If

' Get Header if available

   bFound = False

   If UBOUND(arReportHeaderTemplate) >=0 Then

      For nHeaderIndex = LBOUND(arReportHeaderTemplate) to UBOUND(arReportHeaderTemplate)

         If arReportHeaderTemplate(nHeaderIndex).TemplateID = sTemplateID Then

            bFound = True
            nY = arReportHeaderTemplate(nHeaderIndex).Rectangle.Height
            EXIT FOR

         End If

      Next

   End If

   If bFound = False Then

      nHeaderIndex = -1

   End If

' Get Column Header

   bFound = False

   If UBOUND(arReportColumnHeaderTemplate) >=0 Then

      For nColumnHeaderIndex = LBOUND(arReportColumnHeaderTemplate) to UBOUND(arReportColumnHeaderTemplate)

         If arReportColumnHeaderTemplate(nColumnHeaderIndex).TemplateID = sTemplateID Then

            bFound = True
            nY = nY + arReportColumnHeaderTemplate(nColumnHeaderIndex).Rectangle.Height
            EXIT FOR

         End If

      Next

   End If

' Column Headers are required as a container

   If bFound = False then

      sLastErrorDescription = "Column Header for Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

' Column Templates are required

   If UBOUND(arReportColumns) < 0 Then

      sLastErrorDescription = "Column Header template container for Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

   For nColumnsIndex = LBOUND(arReportColumns) to  UBOUND(arReportColumns)

       If arReportColumns(nColumnsIndex).TemplateID = sTemplateID Then

          AppendElementToArray(arColumns,arReportColumns(nColumnsIndex))  
          
       End If

   Next

' Columns Template are required

   If UBOUND(arColumns) < 0 Then

      sLastErrorDescription = "Column Header template container for Template ID " + sTemplateID + " not found."
      RETURN False
      EXIT FUNCTION

   End If

' Check that arRows is an even multiple of the number of columns

   If (UBOUND(arRows) + 1) MOD (UBOUND(arColumns) + 1) <> 0 Then

      sLastErrorDescription = "Data Rows not a multiple of " + FORMAT(UBOUND(arColumns) + 1) + " for Template ID " + sTemplateID + "."
      RETURN False
      EXIT FUNCTION

   End If

   nReportHeight = arReportTemplate(nIndex).Rectangle.Height - nY
   nReportRemainingHeight = nReportHeight

'Draw Row Container

   uRowRectangle = arReportColumnHeaderTemplate(nColumnHeaderIndex).Rectangle
   nRowY = nY

   For nRowIndex = LBOUND(arRows) To UBOUND(arRows)

' Row Height is supplied by the first row element

       If nReportRemainingHeight < arRows(nRowIndex).Height Then

          PDFEndPage()
          PDFNewPage()
          PDFDrawReportTemplate(sTemplateID)
          nReportRemainingHeight = nReportHeight
          nRowNumber = 0
          nRowY = nY

       End If
 
      nReportRemainingHeight = nReportRemainingHeight - arRows(nRowIndex).Height
      uRowRectangle.Height = arRows(nRowIndex).Height
      nRowNumber = nRowNumber + 1

' Draw Row Container

      PDFRectangle(arReportTemplate(nIndex).X,arReportTemplate(nIndex).Y + nRowY,uRowRectangle)

      For nColumnsIndex = LBOUND(arColumns) TO UBOUND(arColumns)

' Draw Row Column Container

          uRowColumnRectangle = arColumns(nColumnsIndex).Rectangle
          uRowColumnRectangle.Height = arRows(nRowIndex).Height
          uRowColumnRectangle.FillColor = ITEM_IGNORE

' Check for possible background fill color

           If arColumns(nColumnsIndex).OddLineFillColor >= 0 ANDALSO nRowNumber MOD 2 <> 0 Then

              uRowColumnRectangle.FillColor = arColumns(nColumnsIndex).OddLineFillColor 

           End If

           If arColumns(nColumnsIndex).EvenLineFillColor >= 0 ANDALSO nRowNumber MOD 2 = 0 Then

              uRowColumnRectangle.FillColor = arColumns(nColumnsIndex).EvenLineFillColor 

           End If  


           PDFRectangle(arReportTemplate(nIndex).X + arColumns(nColumnsIndex).TotalWidth,arReportTemplate(nIndex).Y _
                                                   + nRowY,uRowColumnRectangle)

' Add report data to columns

           sColumnText = GetStringID(arRows(nRowIndex).StringID)
           nLineHeight = PDFLineHeight(arRows(nRowIndex).TextDescriptor.FontID,arRows(nRowIndex).TextDescriptor.FontSize)
           nXColumnText = arReportTemplate(nIndex).X + arReportColumns(nColumnsIndex).TotalWidth _
                        + arRows(nRowIndex).Margins.left
           nYColumnText = arReportTemplate(nIndex).Y + nRowY _
                        +  arRows(nRowIndex).Margins.top _
                        + nLineHeight
           uMulti.Width = arColumns(nColumnsIndex).Rectangle.Width _
                        -  arRows(nRowIndex).Margins.left _
                        -  arRows(nRowIndex).Margins.right
           uMulti.Height = arRows(0).Height _
                         - arRows(nRowIndex).Margins.top _
                         - arRows(nRowIndex).Margins.bottom
           uMulti.VerticalAlignment = arRows(nRowIndex).VerticalAlignment
           uMulti.TextAttributes = arRows(nRowIndex).TextDescriptor
           PDFMultiLineTextBox(nXColumnText,nYColumnText,uMulti,sColumnText)

           If nColumnsIndex < UBOUND(arColumns) Then

              nRowIndex = nRowIndex + 1

           End If

      Next

      nRowY = nRowY + uRowRectangle.Height

   Next

   RETURN True

End Function

' =====================================================================================
' Properties
' =====================================================================================

Private FUNCTION cPDF.GetLastErrorDescription() AS DWSTRING

   RETURN sLastErrorDescription

End Function

Private SUB cPDF.PDFSetTitle(BYVAL sPDFTitle AS DWSTRING)

    sTitle = sPDFTitle

End Sub

Private SUB cPDF.PDFSetFontSize(BYVAL nFontSize AS LONG)

    If nFontSize > 0 Then

       nDefaultFontSize = nFontSize

    End If

End Sub

Private SUB cPDF.PDFSetPageTextRenderingMode(BYVAL nRendering AS LONG)

    Select Case nRendering

        Case TEXTRENDERING_FILL To TEXTRENDERING_ADDCLIPPING

            nPageRenderingMode = nRendering

    End Select

End Sub

Private SUB cPDF.PDFSetPageWordSpacing(BYVAL nWordSpacing AS DOUBLE)

    If nWordSpacing >= 0 Then

       nPageWordSpacing = nWordSpacing

    End If

End Sub

Private SUB cPDF.PDFSetPageCharacterSpacing(BYVAL nCharacterSpacing AS DOUBLE)

    If nCharacterSpacing >= 0 Then

       nPageCharacterSpacing = nCharacterSpacing

    End If

End Sub

Private SUB cPDF.PDFSetPageHorizontalScaling(BYVAL nHorizontalScaling AS WORD)

    If nHorizontalScaling >= 0 Then

       nPageHorizontalScaling = nHorizontalScaling

    End If

End Sub

Private SUB cPDF.PDFSetPageTextLeading(BYVAL nTextLeading AS DOUBLE)

    If nTextLeading >= 0 Then

       nPageTextLeading = nTextLeading

    End If

End Sub

Private SUB cPDF.PDFSetPaperSize(BYVAL nPaperID AS LONG)

    Select Case nPaperID

        Case PDF_PAPER_A0 To PDF_PAPER_METRIC_ROYAL_OCTAVO

            nCurrentPaperID = nPaperID

    End Select

End Sub

Private FUNCTION cPDF.PDFGetPaperSize() AS LONG

    RETURN nCurrentPaperID

End Function

Private SUB cPDF.PDFSetPaperOrientation(BYVAL nOrientation AS LONG)

    Select Case nOrientation

        Case PDFPAGE_PORTRAIT, PDFPAGE_LANDSCAPE

            nCurrentPaperOrientation = nOrientation

    End Select

End Sub

Private FUNCTION cPDF.PDFGetPaperOrientation() AS LONG

    RETURN nCurrentPaperOrientation

End Function

Private SUB cPDF.PDFSetPaperTopMargin(BYVAL nMargin AS DOUBLE)

    If nMargin > 0 Then

        nCurrentTopMargin = nMargin

    End If

End Sub

Private FUNCTION cPDF.PDFGetPaperTopMargin() AS DOUBLE

    RETURN nCurrentTopMargin

End Function

Private SUB cPDF.PDFSetPaperLeftMargin(BYVAL nMargin AS DOUBLE)

    If nMargin > 0 Then

        nCurrentLeftMargin = nMargin

    End If

End Sub

Private FUNCTION cPDF.PDFGetPaperLeftMargin() AS DOUBLE

    RETURN nCurrentLeftMargin

End Function

Private SUB cPDF.PDFSetPaperBottomMargin(BYVAL nMargin AS DOUBLE)

    If nMargin > 0 Then

        nCurrentBottomMargin = nMargin

    End If

End Sub

Private FUNCTION cPDF.PDFGetPaperBottomMargin() AS DOUBLE

    RETURN nCurrentBottomMargin

End Function

Private SUB cPDF.PDFSetPaperRightMargin(BYVAL nMargin AS DOUBLE)

    If nMargin > 0 Then

        nCurrentRightMargin = nMargin

    End If

End Sub

Private FUNCTION cPDF.PDFGetPaperRightMargin() AS DOUBLE

    RETURN nCurrentRightMargin

End Function

Private SUB cPDF.PDFSetZoom (BYVAL nZoom AS LONG)

    Select Case nZoom

        Case PDF_ZOOM_NONE To PDF_ZOOM_REAL

            nPDF_ZOOM = nZoom

    End Select

End Sub

Private SUB cPDF.PDFSetLayout (BYVAL nLayout AS LONG)

    Select Case nLayout

        Case PDF_LAYOUT_NONE To PDF_LAYOUT_TWOCOLUMN

            nPDF_LAYOUT = nLayout

    End Select

End Sub

Private SUB cPDF.PDFSetFontColor(BYVAL nRGB AS LONG)

    nDefaultFontColor = nRGB

End Sub

Private SUB cPDF.PDFSetProducer(BYVAL sPDFProducer AS DWSTRING)

    sProducer = sPDFProducer

End Sub

Private SUB cPDF.PDFSetAuthor(BYVAL sPDFAuthor AS DWSTRING)

    sAuthor = sPDFAuthor

End Sub

Private SUB cPDF.PDFSetCreator(BYVAL sPDFCreator AS DWSTRING)

    sCreator = sPDFCreator

End Sub

Private SUB cPDF.PDFSetSubject(BYVAL sPDFSubject AS DWSTRING)

    sSubject = sPDFSubject

End Sub

Private SUB cPDF.PDFSetKeywords(BYVAL sPDFKeywords AS DWSTRING)

    sKeywords = sPDFKeywords

End Sub

Private FUNCTION cPDF.PDFGetCurrentFontID() AS DWSTRING

    RETURN sDefaultFontID

End Function

' =====================================================================================
' Set PDF Viewer Preferences if opened by cPDF class
' =====================================================================================

Private SUB cPDF.PDFViewerPreferences(ByVal nThumbnails AS LONG, _
                                      ByVal nHideMenuBar AS LONG, _
                                      ByVal nHideToolBar AS LONG, _
                                      ByVal nShowTitle AS LONG, _
                                      ByVal nHideWindowUI AS LONG, _
                                      ByVal nCenterWindow AS LONG, _
                                      ByVal nFitWindow AS LONG)
    Select Case nThumbnails

        Case 0,1

            nPDF_VIEWER_USE_THUMBNAILS = nThumbnails

    End Select

    Select Case nHideToolBar

        Case 0,1

            nPDF_VIEWER_HIDETOOLBAR = nHideToolBar

    End Select

    Select Case nHideMenuBar

        Case 0,1

            nPDF_VIEWER_HIDEMENUBAR = nHideMenuBar

    End Select

    Select Case nShowTitle

        Case 0,1

            nPDF_VIEWER_SHOWTITLE = nShowTitle

    End Select

    Select Case nHideWindowUI

        Case 0,1

            nPDF_VIEWER_HIDEWINDOWUI = nHideWindowUI

    End Select

    Select Case nCenterWindow

        Case 0,1

            nPDF_VIEWER_CENTER_WINDOW = nCenterWindow

    End Select

    Select Case nFitWindow

        Case 0,1

            nPDF_VIEWER_FIT_WINDOW = nFitWindow

    End Select

End Sub

' =====================================================================================
' Create Font Class Consolas
' =====================================================================================

Private Sub cPDF.CreateConsolasFont()

DIM uDescriptor       AS FontDescriptor
DIM sFontKey          AS DWSTRING
DIM sWidthList        AS DWSTRING
DIM uFont             AS PDFFontID
DIM uWidths           AS FontIDWidths

' Consolas Normal

    uDescriptor.FontName = "Consolas"
    uDescriptor.FontID = FONT_CONSOLAS
    uDescriptor.FontStyle = PDF_FONT_NORMAL
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 690
    uDescriptor.FontCapHeight = 638
    uDescriptor.FontDescent = -200
    uDescriptor.FontFlags = 33
    uDescriptor.FontRectLeft = -298
    uDescriptor.FontRectTop = -251
    uDescriptor.FontRectRight = 678
    uDescriptor.FontRectBottom = 1012
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 80
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -106

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",549,549,549,549,549,549,549,549,549,549,549,549,549,0,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Consolas Bold

    uDescriptor.FontName = "Consolas-Bold"
    uDescriptor.FontID = FONT_CONSOLAS
    uDescriptor.FontStyle = PDF_FONT_BOLD
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 690
    uDescriptor.FontCapHeight = 638
    uDescriptor.FontDescent = -194
    uDescriptor.FontFlags = 33
    uDescriptor.FontRectLeft = -365
    uDescriptor.FontRectTop = -258
    uDescriptor.FontRectRight = 701
    uDescriptor.FontRectBottom = 984
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 135
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -106

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",549,549,549,549,549,549,549,549,549,549,549,549,549,0,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Consolas Italic

    uDescriptor.FontName = "Consolas-Italic"
    uDescriptor.FontID = FONT_CONSOLAS
    uDescriptor.FontStyle = PDF_FONT_ITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 690
    uDescriptor.FontCapHeight = 638
    uDescriptor.FontDescent = -200
    uDescriptor.FontFlags = 65
    uDescriptor.FontRectLeft = -233
    uDescriptor.FontRectTop = -258
    uDescriptor.FontRectRight = 704
    uDescriptor.FontRectBottom = 1012
    uDescriptor.FontItalicAngle = -11
    uDescriptor.FontStemV = 109
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -106

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",549,549,549,549,549,549,549,549,549,549,549,549,549,0,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Consolas Bold Italic

    uDescriptor.FontName = "Consolas-BoldItalic"
    uDescriptor.FontID = FONT_CONSOLAS
    uDescriptor.FontStyle = PDF_FONT_BOLDITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 690
    uDescriptor.FontCapHeight = 638
    uDescriptor.FontDescent = -194
    uDescriptor.FontFlags = 65
    uDescriptor.FontRectLeft = -300
    uDescriptor.FontRectTop = -258
    uDescriptor.FontRectRight = 720
    uDescriptor.FontRectBottom = 1063
    uDescriptor.FontItalicAngle = -11
    uDescriptor.FontStemV = 150
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -106

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",549,549,549,549,549,549,549,549,549,549,549,549,549,0,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549," _
      + "549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,549,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

End Sub

' =====================================================================================
' Create Font Class Arial
' =====================================================================================

Private Sub cPDF.CreateArialFont()

DIM uDescriptor       AS FontDescriptor
DIM sFontKey          AS DWSTRING
DIM sWidthList        AS DWSTRING
DIM uFont             AS PDFFontID
DIM uWidths           AS FontIDWidths

' Arial Normal

    uDescriptor.FontName = "Arial"
    uDescriptor.FontID = FONT_ARIAL
    uDescriptor.FontStyle = PDF_FONT_NORMAL
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 716
    uDescriptor.FontCapHeight = 716
    uDescriptor.FontDescent = -199
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -665
    uDescriptor.FontRectTop = -325
    uDescriptor.FontRectRight = 2000
    uDescriptor.FontRectBottom = 1040
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 88
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -106


' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

    sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
       + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
       + "277,277,354,556,556,889,666,190,333,333,389,583,277,333,277,277," _
       + "556,556,556,556,556,556,556,556,556,556,277,277,583,583,583,556," _
       + "1015,666,666,722,722,666,610,777,722,277,500,666,556,833,722,777," _
       + "666,777,722,666,610,722,666,943,666,666,610,277,277,277,469,556," _
       + "333,556,556,500,556,556,277,556,556,222,222,500,222,833,556,556," _
       + "556,556,333,500,277,556,500,722,500,500,500,333,259,333,583,0," _
       + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
       + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
       + "277,333,556,556,556,556,259,556,333,736,370,556,583,333,736,552," _
       + "399,177,333,333,333,576,537,333,333,333,365,556,833,833,833,610," _
       + "666,666,666,666,666,666,1000,722,666,666,666,666,277,277,277,277," _
       + "722,722,777,777,777,777,777,583,777,722,722,722,722,666,666,610," _
       + "556,556,556,556,556,556,889,500,556,556,556,556,277,277,277,277," _
       + "556,556,556,556,556,556,556,548,610,556,556,556,556,500,556,500,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Arial Bold

    uDescriptor.FontName = "Arial-BoldMT"
    uDescriptor.FontID = FONT_ARIAL
    uDescriptor.FontStyle = PDF_FONT_BOLD
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 716
    uDescriptor.FontCapHeight = 716
    uDescriptor.FontDescent = -197
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -628
    uDescriptor.FontRectTop = -377
    uDescriptor.FontRectRight = 2000
    uDescriptor.FontRectBottom = 1056
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 136
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 105
    uDescriptor.FontUnderlinePosition = -106

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "277,333,474,556,556,889,722,237,333,333,389,583,277,333,277,277," _
      + "556,556,556,556,556,556,556,556,556,556,333,333,583,583,583,610," _
      + "975,722,722,722,722,666,610,777,722,277,556,722,610,833,722,777," _
      + "666,777,722,666,610,722,666,943,666,666,610,333,277,333,583,556," _
      + "333,556,610,556,610,556,333,610,610,277,277,556,277,889,610,610," _
      + "610,610,389,556,333,610,556,777,556,556,500,389,279,389,583,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "277,333,556,556,556,556,279,556,333,736,370,556,583,333,736,552," _
      + "399,548,333,333,333,576,556,333,333,333,365,556,833,833,833,610," _
      + "722,722,722,722,722,722,1000,722,666,666,666,666,277,277,277,277," _
      + "722,722,777,777,777,777,777,583,777,722,722,722,722,666,666,610," _
      + "556,556,556,556,556,556,889,556,556,556,556,556,277,277,277,277," _
      + "610,610,610,610,610,610,610,548,610,610,610,610,610,556,610,556,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Arial Italic

    uDescriptor.FontName = "Arial-ItalicMT"
    uDescriptor.FontID = FONT_ARIAL
    uDescriptor.FontStyle = PDF_FONT_ITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 716
    uDescriptor.FontCapHeight = 716
    uDescriptor.FontDescent = -199
    uDescriptor.FontFlags = 65
    uDescriptor.FontRectLeft = -518
    uDescriptor.FontRectTop = -325
    uDescriptor.FontRectRight = 1359
    uDescriptor.FontRectBottom = 998
    uDescriptor.FontItalicAngle = -12
    uDescriptor.FontStemV = 88
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -106

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "277,277,354,556,556,889,666,190,333,333,389,583,277,333,277,277," _
      + "556,556,556,556,556,556,556,556,556,556,277,277,583,583,583,556," _
      + "1015,666,666,722,722,666,610,777,722,277,500,666,556,833,722,777," _
      + "666,777,722,666,610,722,666,943,666,666,610,277,277,277,469,556," _
      + "333,556,556,500,556,556,277,556,556,222,222,500,222,833,556,556," _
      + "556,556,333,500,277,556,500,722,500,500,500,333,259,333,583,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "277,333,556,556,556,556,259,556,333,736,370,556,583,333,736,552," _
      + "399,548,333,333,333,576,537,333,333,333,365,556,833,833,833,610," _
      + "666,666,666,666,666,666,1000,722,666,666,666,666,277,277,277,277," _
      + "722,722,777,777,777,777,777,583,777,722,722,722,722,666,666,610," _
      + "556,556,556,556,556,556,889,500,556,556,556,556,277,277,277,277," _
      + "556,556,556,556,556,556,556,548,610,556,556,556,556,500,556,500,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Arial Bold Italic

    uDescriptor.FontName = "Arial-BoldItalicMT"
    uDescriptor.FontID = FONT_ARIAL
    uDescriptor.FontStyle = PDF_FONT_BOLDITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 716
    uDescriptor.FontCapHeight = 716
    uDescriptor.FontDescent = -198
    uDescriptor.FontFlags = 321
    uDescriptor.FontRectLeft = -560
    uDescriptor.FontRectTop = -377
    uDescriptor.FontRectRight = 1391
    uDescriptor.FontRectBottom = 1018
    uDescriptor.FontItalicAngle = -12
    uDescriptor.FontStemV = 153
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 105
    uDescriptor.FontUnderlinePosition = -106

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "277,333,474,556,556,889,722,237,333,333,389,583,277,333,277,277," _
      + "556,556,556,556,556,556,556,556,556,556,333,333,583,583,583,610," _
      + "975,722,722,722,722,666,610,777,722,277,556,722,610,833,722,777," _
      + "666,777,722,666,610,722,666,943,666,666,610,333,277,333,583,556," _
      + "333,556,610,556,610,556,333,610,610,277,277,556,277,889,610,610," _
      + "610,610,389,556,333,610,556,777,556,556,500,389,279,389,583,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "277,333,556,556,556,556,279,556,333,736,370,556,583,333,736,552," _
      + "399,548,333,333,333,576,556,333,333,333,365,556,833,833,833,610," _
      + "722,722,722,722,722,722,1000,722,666,666,666,666,277,277,277,277," _
      + "722,722,777,777,777,777,777,583,777,722,722,722,722,666,666,610," _
      + "556,556,556,556,556,556,889,556,556,556,556,556,277,277,277,277," _
      + "610,610,610,610,610,610,610,548,610,610,610,610,610,556,610,556,"


    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

End Sub

' =====================================================================================
' Create Font Class Verdana
' =====================================================================================

Private Sub cPDF.CreateVerdanaFont()

DIM uDescriptor       AS FontDescriptor
DIM sFontKey          AS DWSTRING
DIM sWidthList        AS DWSTRING
DIM uFont             AS PDFFontID
DIM uWidths           AS FontIDWidths

' Verdana Normal

    uDescriptor.FontName = "Verdana"
    uDescriptor.FontID = FONT_VERDANA
    uDescriptor.FontStyle = PDF_FONT_NORMAL
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 760
    uDescriptor.FontCapHeight = 727
    uDescriptor.FontDescent = -201
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -560
    uDescriptor.FontRectTop = -304
    uDescriptor.FontRectRight = 1523
    uDescriptor.FontRectBottom = 1051
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 92
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 58
    uDescriptor.FontUnderlinePosition = -87

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "351,393,458,818,635,1076,726,268,454,454,635,818,363,454,363,454," _
      + "635,635,635,635,635,635,635,635,635,635,454,454,818,818,818,545," _
      + "1000,683,685,698,770,632,574,775,751,420,454,692,556,842,748,787," _
      + "603,787,695,683,616,731,683,988,685,615,685,454,454,454,818,635," _
      + "635,600,623,520,623,595,351,623,632,274,344,591,274,972,632,606," _
      + "623,623,426,520,394,632,591,818,591,591,525,634,454,634,818,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "351,393,635,635,635,635,454,635,635,1000,545,644,818,454,1000,635," _
      + "541,818,541,541,635,641,635,363,635,541,545,644,1000,1000,1000,545," _
      + "683,683,683,683,683,683,984,698,632,632,632,632,420,420,420,420," _ 
      + "775,748,787,787,787,787,787,818,787,731,731,731,731,615,605,620," _
      + "600,600,600,600,600,600,955,520,595,595,595,595,274,274,274,274," _
      + "611,632,606,606,606,606,606,818,606,632,632,632,632,591,623,591,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Verdana Bold

    uDescriptor.FontName = "Verdana-Bold"
    uDescriptor.FontID = FONT_VERDANA
    uDescriptor.FontStyle = PDF_FONT_BOLD
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 1005
    uDescriptor.FontCapHeight = 765
    uDescriptor.FontDescent = -210
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -550
    uDescriptor.FontRectTop = -304
    uDescriptor.FontRectRight = 1708
    uDescriptor.FontRectBottom = 1072
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 144
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 58
    uDescriptor.FontUnderlinePosition = -68

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "351,402,587,867,710,1271,862,332,543,543,710,867,361,479,361,689," _
      + "710,710,710,710,710,710,710,710,710,710,402,402,867,867,867,616," _
      + "963,776,761,723,830,683,650,811,837,545,555,770,637,947,846,850," _
      + "732,850,782,710,681,812,763,1128,763,736,691,543,689,543,867,710," _
      + "710,667,699,588,699,664,422,699,712,341,402,670,341,1058,712,686," _
      + "699,699,497,593,455,712,649,979,668,650,596,710,543,710,867,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "341,402,710,710,710,710,543,710,710,963,597,849,867,479,963,710," _
      + "587,867,597,597,710,721,710,361,710,597,597,849,1181,1181,1181,616," _
      + "776,776,776,776,776,776,1093,723,683,683,683,683,545,545,545,545," _
      + "830,846,850,850,850,850,850,867,850,812,812,812,812,736,734,712," _
      + "667,667,667,667,667,667,1018,588,664,664,664,664,341,341,341,341," _
      + "679,712,686,686,686,686,686,867,686,712,712,712,712,650,699,650,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Verdana Italic

    uDescriptor.FontName = "Verdana-Italic"
    uDescriptor.FontID = FONT_VERDANA
    uDescriptor.FontStyle = PDF_FONT_ITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 760
    uDescriptor.FontCapHeight = 765
    uDescriptor.FontDescent = -201
    uDescriptor.FontFlags = 65
    uDescriptor.FontRectLeft = -454
    uDescriptor.FontRectTop = -304
    uDescriptor.FontRectRight = 1585
    uDescriptor.FontRectBottom = 1051
    uDescriptor.FontItalicAngle = -13
    uDescriptor.FontStemV = 50
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 59
    uDescriptor.FontUnderlinePosition = -88
    uDescriptor.FontCharSpacingAdjust = .3

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,393,458,818,635,1076,726,268,454,454,635,818,363,454,363,454," _
      + "635,635,635,635,635,635,635,635,635,635,454,454,818,818,818,545," _
      + "1000,682,685,698,765,632,574,775,751,420,454,692,556,842,748,787," _
      + "603,787,695,683,616,731,682,990,685,615,685,454,454,454,818,635," _
      + "635,600,623,520,623,595,351,621,632,274,344,586,274,973,632,606," _
      + "623,623,426,520,394,632,590,818,591,590,525,634,454,634,818,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "351,393,635,635,635,635,454,635,635,1000,545,644,818,454,1000,635," _
      + "541,818,541,541,635,641,635,363,635,541,545,644,1000,1000,1000,545," _
      + "682,682,682,682,682,682,989,698,632,632,632,632,420,420,420,420," _
      + "765,748,787,787,787,787,787,818,787,731,731,731,731,615,605,620," _
      + "600,600,600,600,600,600,954,520,595,595,595,595,274,274,274,274," _
      + "611,632,606,606,606,606,606,818,606,632,632,632,632,590,623,590,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Verdana Bold Italic

    uDescriptor.FontName = "Verdana-BoldItalic"
    uDescriptor.FontID = FONT_VERDANA
    uDescriptor.FontStyle = PDF_FONT_BOLDITALIC
    uDescriptor.FontReferenced = 1
    uDescriptor.FontStandard = 1
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 1760
    uDescriptor.FontCapHeight = 727
    uDescriptor.FontDescent = -201
    uDescriptor.FontFlags = 321
    uDescriptor.FontRectLeft = -538
    uDescriptor.FontRectTop = -304
    uDescriptor.FontRectRight = 1756
    uDescriptor.FontRectBottom = 1072
    uDescriptor.FontItalicAngle = -13
    uDescriptor.FontStemV = 165
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 103
    uDescriptor.FontUnderlinePosition = -68
    uDescriptor.FontCharSpacingAdjust = -.2

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "341,402,587,867,710,1271,862,332,543,543,710,867,361,479,361,689," _
      + "710,710,710,710,710,710,710,710,710,710,402,402,867,867,867,616," _
      + "963,776,761,723,830,683,650,811,837,545,555,770,637,947,846,850," _
      + "732,850,782,710,681,812,763,1128,763,736,691,543,689,543,867,710," _
      + "710,667,699,588,699,664,422,699,712,341,402,670,341,1058,712,685," _
      + "699,699,497,593,455,712,648,979,668,650,596,710,543,710,867,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "341,402,710,710,710,710,543,710,710,963,597,849,867,479,963,710," _
      + "587,867,597,597,710,721,710,361,710,597,597,849,1181,1181,1181,616," _
      + "776,776,776,776,776,776,1093,723,683,683,683,683,545,545,545,545," _
      + "830,209,850,850,850,850,850,867,850,812,812,812,812,736,734,712," _
      + "667,667,667,667,667,667,1018,588,664,664,664,664,341,341,341,341," _
      + "679,712,685,685,685,685,685,867,685,712,712,712,712,650,699,650,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

End Sub

' =====================================================================================
' Create Font Class Trebuchet
' =====================================================================================

Private Sub cPDF.CreateTrebuchetFont()

DIM uDescriptor       AS FontDescriptor
DIM sFontKey          AS DWSTRING
DIM sWidthList        AS DWSTRING
DIM uFont             AS PDFFontID
DIM uWidths           AS FontIDWidths

' Trebuchet Normal

    uDescriptor.FontName = "TrebuchetMS"
    uDescriptor.FontID = FONT_TREBUCHET
    uDescriptor.FontStyle = PDF_FONT_NORMAL
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 737
    uDescriptor.FontCapHeight = 715
    uDescriptor.FontDescent = -205
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -533
    uDescriptor.FontRectTop = -263
    uDescriptor.FontRectRight = 1311
    uDescriptor.FontRectBottom = 985
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 45
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 58
    uDescriptor.FontUnderlinePosition = -91

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,324,524,524,600,706,159,367,367,367,524,367,367,367,524," _
      + "524,524,524,524,524,524,524,524,524,524,367,367,524,524,524,367," _
      + "770,589,565,598,613,535,524,676,654,278,476,575,506,709,638,673," _
      + "557,675,582,480,580,648,587,852,556,570,550,367,355,367,524,524," _
      + "524,525,557,495,557,545,369,501,546,285,366,504,294,830,546,536," _
      + "557,557,388,404,396,546,489,744,500,493,474,367,524,367,524,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,524,524,524,570,524,453,524,712,367,524,524,367,712,524," _
      + "524,524,451,453,524,546,524,367,524,451,367,524,814,814,814,367," _
      + "589,589,589,589,589,589,866,598,535,535,535,535,278,278,278,278," _
      + "613,638,673,673,673,673,673,524,656,648,648,648,648,570,555,546," _
      + "525,525,525,525,525,525,873,495,545,545,545,545,285,285,285,285," _
      + "549,546,536,536,536,536,536,524,545,546,546,546,546,493,553,493,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Trebuchet Bold


    uDescriptor.FontName = "TrebuchetMS-Bold"
    uDescriptor.FontID = FONT_TREBUCHET
    uDescriptor.FontStyle = PDF_FONT_BOLD
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 737
    uDescriptor.FontCapHeight = 715
    uDescriptor.FontDescent = -205
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -583
    uDescriptor.FontRectTop = -270
    uDescriptor.FontRectRight = 1387
    uDescriptor.FontRectBottom = 981
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 47
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 58
    uDescriptor.FontUnderlinePosition = -91

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,366,585,585,684,706,229,367,367,432,585,367,367,367,390," _
      + "585,585,585,585,585,585,585,585,585,585,367,367,585,585,585,437," _
      + "770,633,595,611,642,568,583,671,683,278,532,617,552,745,667,703," _
      + "586,708,610,511,611,677,621,883,600,613,560,401,355,401,585,585," _
      + "585,532,581,511,580,574,369,501,592,298,366,547,294,859,590,565," _
      + "582,583,427,430,396,590,527,783,552,533,528,433,585,433,585,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,585,524,585,570,585,453,585,712,429,585,585,367,712,585," _
      + "585,585,451,453,585,546,524,367,585,451,429,585,814,814,814,437," _
      + "633,633,633,633,633,633,935,611,568,568,568,568,278,278,278,278," _
      + "642,667,703,703,703,703,703,585,683,677,677,677,677,613,557,546," _
      + "532,532,532,532,532,532,862,511,574,574,574,574,298,298,298,298," _
      + "565,590,565,565,565,565,565,585,565,590,590,590,590,533,582,533,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Trebuchet Italic

    uDescriptor.FontName = "TrebuchetMS-Italic"
    uDescriptor.FontID = FONT_TREBUCHET
    uDescriptor.FontStyle = PDF_FONT_ITALIC
    uDescriptor.FontReferenced = 1
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 737
    uDescriptor.FontCapHeight = 715
    uDescriptor.FontDescent = -205
    uDescriptor.FontFlags = 65
    uDescriptor.FontRectLeft = -450
    uDescriptor.FontRectTop = -258
    uDescriptor.FontRectRight = 1363
    uDescriptor.FontRectBottom = 966
    uDescriptor.FontItalicAngle = -10
    uDescriptor.FontStemV = 45
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 58
    uDescriptor.FontUnderlinePosition = -91

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,324,524,480,600,706,159,367,367,367,524,367,367,367,524," _
      + "524,524,524,524,524,524,524,524,524,524,367,367,524,524,524,367," _
      + "770,610,565,598,613,535,524,676,654,278,476,575,506,761,638,673," _
      + "543,673,582,480,580,648,587,852,556,570,550,367,355,367,524,524," _
      + "524,525,557,459,557,537,401,501,557,306,366,504,320,830,546,536," _
      + "557,557,416,404,419,556,489,744,500,49,474,367,524,367,524,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,524,529,524,556,524,453,524,712,452,524,524,367,712,524," _
      + "524,524,451,451,524,556,598,367,524,451,458,524,814,814,814,367," _
      + "610,610,610,610,610,610,866,598,535,535,535,535,278,278,278,278," _
      + "613,638,673,673,673,673,673,524,673,648,648,648,648,570,543,546," _
      + "525,525,525,525,525,525,844,459,537,537,537,537,306,306,306,306," _
      + "549,546,536,536,536,536,536,524,536,556,556,556,556,493,557,493,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Trebuchet Bold Italic

    uDescriptor.FontName = "TrebuchetMS-BoldItalic"
    uDescriptor.FontID = FONT_TREBUCHET
    uDescriptor.FontStyle = PDF_FONT_BOLDITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 737
    uDescriptor.FontCapHeight = 715
    uDescriptor.FontDescent = -205
    uDescriptor.FontFlags = 321
    uDescriptor.FontRectLeft = -492
    uDescriptor.FontRectTop = -279
    uDescriptor.FontRectRight = 1411
    uDescriptor.FontRectBottom = 992
    uDescriptor.FontItalicAngle = -10
    uDescriptor.FontStemV = 48
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 58
    uDescriptor.FontUnderlinePosition = -91

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,390,585,585,732,706,301,367,367,432,585,367,367,367,396," _
      + "585,585,585,585,585,585,585,585,585,585,367,367,585,585,585,396," _
      + "770,613,589,612,632,593,585,676,678,278,498,649,528,786,660,702," _
      + "583,769,623,501,685,661,683,926,656,683,611,485,477,485,585,585," _
      + "585,592,593,492,593,551,410,535,562,326,387,539,319,830,562,569," _
      + "598,598,446,458,437,557,552,773,575,563,532,485,585,485,585,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "301,367,585,585,585,585,585,585,585,712,427,524,585,367,712,585," _
      + "585,585,464,463,585,557,585,367,585,478,433,524,876,876,876,367," _
      + "613,613,613,613,613,613,959,612,593,593,593,593,278,278,278,278," _
      + "654,660,702,702,702,702,702,585,702,661,661,661,661,683,561,577," _
      + "592,592,592,592,592,592,893,492,551,551,551,551,326,326,326,326," _
      + "569,562,569,569,569,569,569,585,569,557,557,557,557,563,598,563,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

End Sub

' =====================================================================================
' Create Font Class Calibri
' =====================================================================================

Private SUB cPDF.CreateCalibriFont()

DIM uDescriptor       AS FontDescriptor
DIM sFontKey          AS DWSTRING
DIM sWidthList        AS DWSTRING
DIM uFont             AS PDFFontID
DIM uWidths           AS FontIDWidths

' Calibri Normal

    uDescriptor.FontName = "Calibri"
    uDescriptor.FontID = FONT_CALIBRI
    uDescriptor.FontStyle = PDF_FONT_NORMAL
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 632
    uDescriptor.FontCapHeight = 571
    uDescriptor.FontDescent = -173
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -502
    uDescriptor.FontRectTop = -313
    uDescriptor.FontRectRight = 1241
    uDescriptor.FontRectBottom = 1027
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 89
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,400,498,506,714,682,220,303,303,498,498,249,306,252,386," _
      + "506,506,506,506,506,506,506,506,506,506,267,267,498,498,498,463," _
      + "894,578,543,533,615,488,459,630,623,251,318,519,420,854,645,662," _
      + "516,672,542,459,487,641,567,889,519,487,468,306,386,306,498,498," _
      + "291,479,525,422,525,497,305,470,525,229,239,454,229,798,525,527," _
      + "525,525,348,391,334,525,451,714,433,452,395,314,460,314,498,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,498,506,498,506,498,498,392,834,402,512,498,306,506,394," _
      + "338,498,335,334,291,549,585,252,307,246,422,512,636,671,675,463," _
      + "578,578,578,578,578,578,763,533,488,488,488,488,251,251,251,251," _
      + "624,645,662,662,662,662,662,498,663,641,641,641,641,487,516,527," _
      + "479,479,479,479,479,479,772,422,497,497,497,497,229,229,229,229," _
      + "525,525,527,527,527,527,527,498,529,525,525,525,525,452,525,452,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Calibri Bold

    uDescriptor.FontName = "Calibri-Bold"
    uDescriptor.FontID = FONT_CALIBRI
    uDescriptor.FontStyle = PDF_FONT_BOLD
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 632
    uDescriptor.FontCapHeight = 632
    uDescriptor.FontDescent = -173
    uDescriptor.FontFlags = 32
    uDescriptor.FontRectLeft = -519
    uDescriptor.FontRectTop = -350
    uDescriptor.FontRectRight = 1263
    uDescriptor.FontRectBottom = 1040
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 140
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,438,498,506,729,704,233,311,311,498,498,257,306,267,429," _
      + "506,506,506,506,506,506,506,506,506,506,275,275,498,498,498,463," _
      + "898,605,560,529,630,487,458,637,630,266,331,546,422,874,658,676," _
      + "532,686,562,472,495,652,591,906,550,519,478,324,429,324,498,498," _
      + "300,493,536,418,536,503,316,474,536,245,255,479,245,813,536,537," _
      + "536,536,355,398,346,536,473,745,459,473,397,343,475,343,498,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,498,506,498,506,498,498,414,834,416,538,498,306,506,390," _
      + "342,498,337,335,300,563,597,267,303,252,435,538,657,690,701,463," _
      + "605,605,605,605,605,605,775,529,487,487,487,487,266,266,266,266," _
      + "639,658,676,676,676,676,676,498,680,652,652,652,652,519,532,554," _
      + "493,493,493,493,493,493,774,418,503,503,503,503,245,245,245,245," _
      + "536,536,537,537,537,537,537,498,543,536,536,536,536,473,536,473,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Calibri Italic

    uDescriptor.FontName = "Calibri-Italic"
    uDescriptor.FontID = FONT_CALIBRI
    uDescriptor.FontStyle = PDF_FONT_ITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 632
    uDescriptor.FontCapHeight = 632
    uDescriptor.FontDescent = -135
    uDescriptor.FontFlags = 96
    uDescriptor.FontRectLeft = -724
    uDescriptor.FontRectTop = -269
    uDescriptor.FontRectRight = 1260
    uDescriptor.FontRectBottom = 1027
    uDescriptor.FontItalicAngle = -11
    uDescriptor.FontStemV = 78
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,400,498,506,714,682,220,303,303,498,498,249,306,252,387," _
      + "506,506,506,506,506,506,506,506,506,506,267,267,498,498,498,463," _
      + "894,578,543,522,615,488,459,630,623,251,318,519,420,854,644,654," _
      + "516,664,542,452,487,641,567,890,519,487,468,306,384,306,498,498," _
      + "291,514,514,416,514,477,305,514,514,229,239,454,229,791,514,513," _
      + "514,514,342,389,334,514,445,714,433,447,395,314,460,314,498,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,498,506,498,506,498,498,392,834,430,512,498,306,506,394," _
      + "338,498,335,334,291,538,585,252,307,246,422,512,636,671,675,463," _
      + "578,578,578,578,578,578,763,522,488,488,488,488,251,251,251,251," _
      + "624,644,654,654,654,654,654,498,657,641,641,641,641,487,516,527," _
      + "514,514,514,514,514,514,754,416,477,477,477,477,229,229,229,229," _
      + "525,514,513,513,513,513,513,498,529,514,514,514,514,447,514,447,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Calibri Bold Italic

    uDescriptor.FontName = "Calibri-BoldItalic"
    uDescriptor.FontID = FONT_CALIBRI
    uDescriptor.FontStyle = PDF_FONT_BOLDITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 632
    uDescriptor.FontCapHeight = 632
    uDescriptor.FontDescent = -136
    uDescriptor.FontFlags = 96
    uDescriptor.FontRectLeft = -691
    uDescriptor.FontRectTop = -269
    uDescriptor.FontRectRight = 1330
    uDescriptor.FontRectBottom = 1040
    uDescriptor.FontItalicAngle = -11
    uDescriptor.FontStemV = 130
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180
'    uDescriptor.FontCharSpacingAdjust = -.3

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,438,498,506,729,704,233,311,311,498,498,257,306,267,434," _
      + "506,506,506,506,506,506,506,506,506,506,275,275,498,498,498,463," _
      + "898,605,560,518,630,487,458,637,630,266,331,546,422,874,656,668," _
      + "532,677,562,465,495,652,591,906,550,519,478,324,424,324,498,498," _
      + "300,527,527,411,527,491,316,527,527,245,255,479,245,803,527,527," _
      + "527,527,352,394,346,527,469,745,459,470,397,343,475,343,498,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "226,325,498,506,498,506,498,498,414,834,440,538,498,306,506,390," _
      + "342,498,337,335,300,553,597,267,303,252,435,538,657,690,701,463," _
      + "605,605,605,605,605,605,775,518,487,487,487,487,266,266,266,266," _
      + "639,656,668,668,668,668,668,498,677,652,652,652,652,519,532,554," _
      + "527,225,226,227,228,527,763,411,491,491,491,491,245,245,245,245," _
      + "536,527,527,527,527,527,527,498,543,527,527,527,527,470,527,470,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

End Sub

' =====================================================================================
' Create Font Class Times New Roman
' =====================================================================================

Private SUB cPDF.CreateTimesNewRomanFont()

DIM uDescriptor       AS FontDescriptor
DIM sFontKey          AS DWSTRING
DIM sWidthList        AS DWSTRING
DIM uFont             AS PDFFontID
DIM uWidths           AS FontIDWidths

' Times New Roman Normal

    uDescriptor.FontName = "TimesNewRomanPSMT"
    uDescriptor.FontID = FONT_TIMESNEWROMAN
    uDescriptor.FontStyle = PDF_FONT_NORMAL
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 694
    uDescriptor.FontCapHeight = 662
    uDescriptor.FontDescent = -214
    uDescriptor.FontFlags = 34
    uDescriptor.FontRectLeft = -569
    uDescriptor.FontRectTop = -307
    uDescriptor.FontRectRight = 2046
    uDescriptor.FontRectBottom = 1040
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 80
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,333,408,500,500,833,777,180,333,333,500,563,250,333,250,277," _
      + "500,500,500,500,500,500,500,500,500,500,277,277,563,563,563,443," _
      + "920,722,666,666,722,610,556,722,722,333,389,722,610,889,722,722," _
      + "556,722,666,556,610,722,722,943,722,722,610,333,277,333,469,500," _
      + "333,443,500,443,500,443,333,500,500,277,277,500,277,777,500,500," _
      + "500,500,333,389,277,500,500,722,500,500,443,479,200,479,541,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,333,500,500,500,500,200,500,333,759,275,500,563,333,759,500," _
      + "399,548,299,299,333,576,453,333,333,299,310,500,750,750,750,443," _
      + "722,722,722,722,722,722,889,666,610,610,610,610,333,333,333,333," _
      + "722,722,722,722,722,722,722,563,722,722,722,722,722,722,556,500," _
      + "443,443,443,443,443,443,666,443,443,443,443,443,277,277,277,277," _
      + "500,500,500,500,500,500,500,500,500,500,500,500,500,500,500,500,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Times New Roman Bold

    uDescriptor.FontName = "TimesNewRomanPS-BoldMT"
    uDescriptor.FontID = FONT_TIMESNEWROMAN
    uDescriptor.FontStyle = PDF_FONT_BOLD
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 662
    uDescriptor.FontCapHeight = 662
    uDescriptor.FontDescent = -214
    uDescriptor.FontFlags = 262178
    uDescriptor.FontRectLeft = -558
    uDescriptor.FontRectTop = -328
    uDescriptor.FontRectRight = 2000
    uDescriptor.FontRectBottom = 1056
    uDescriptor.FontItalicAngle = 0
    uDescriptor.FontStemV = 140
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180


' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,333,555,500,500,1000,833,277,333,333,500,569,250,333,250,277," _
      + "500,500,500,500,500,500,500,500,500,500,333,333,569,569,569,500," _
      + "930,722,666,722,722,666,610,777,777,389,500,777,666,943,722,777," _
      + "610,777,722,556,666,722,722,1000,722,722,666,333,277,333,581,500," _
      + "333,500,556,443,556,443,333,500,556,277,333,556,277,833,556,500," _
      + "556,556,443,389,333,556,500,722,500,500,443,394,220,394,520,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,333,500,500,500,500,220,500,333,747,299,500,569,333,747,500," _
      + "399,548,299,299,333,576,540,333,333,299,330,500,750,750,750,500," _
      + "722,722,722,722,722,722,1000,722,666,666,666,666,389,389,389,389," _
      + "722,722,777,777,777,777,777,569,777,722,722,722,722,722,610,556," _
      + "500,500,500,500,500,500,722,443,443,443,443,443,277,277,277,277," _
      + "500,556,500,500,500,500,500,548,500,556,556,556,556,500,556,500,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Times New Roman Italic

    uDescriptor.FontName = "TimesNewRomanPS-ItalicMT"
    uDescriptor.FontID = FONT_TIMESNEWROMAN
    uDescriptor.FontStyle = PDF_FONT_ITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 694
    uDescriptor.FontCapHeight = 662
    uDescriptor.FontDescent = -214
    uDescriptor.FontFlags = 34
    uDescriptor.FontRectLeft = -498
    uDescriptor.FontRectTop = -307
    uDescriptor.FontRectRight = 1334
    uDescriptor.FontRectBottom = 1024
    uDescriptor.FontItalicAngle = -16.333
    uDescriptor.FontStemV = 73
    uDescriptor.FontWeight = 400
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,333,419,500,500,833,777,213,333,333,500,674,250,333,250,277," _
      + "500,500,500,500,500,500,500,500,500,500,333,333,674,674,674,500," _
      + "919,610,610,666,722,610,610,722,722,333,443,666,556,833,666,722," _
      + "610,722,610,500,556,722,610,833,610,556,556,389,277,389,421,500," _
      + "333,500,500,443,500,443,277,500,500,277,277,443,277,722,500,500," _
      + "500,500,389,389,277,500,443,666,443,443,389,399,274,399,541,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,389,500,500,500,500,274,500,333,759,275,500,674,333,759,500," _
      + "399,548,299,299,333,576,522,250,333,299,310,500,750,750,750,500," _
      + "610,610,610,610,610,610,889,666,610,610,610,610,333,333,333,333," _
      + "722,666,722,722,722,722,722,674,722,722,722,722,722,556,610,500 ," _
      + "500,500,500,500,500,500,666,443,443,443,443,443,277,277,277,277," _
      + "500,500,500,500,500,500,500,548,500,500,500,500,500,443,500,443,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

' Times New Roman Bold Italic

    uDescriptor.FontName = "TimesNewRomanPS-BoldItalicMT"
    uDescriptor.FontID = FONT_TIMESNEWROMAN
    uDescriptor.FontStyle = PDF_FONT_BOLDITALIC
    uDescriptor.FontReferenced = 0
    uDescriptor.FontStandard = 0
    uDescriptor.FontType = FONT_TRUETYPE
    uDescriptor.FontAscent = 677
    uDescriptor.FontCapHeight = 662
    uDescriptor.FontDescent = -214
    uDescriptor.FontFlags = 262212
    uDescriptor.FontRectLeft = -548
    uDescriptor.FontRectTop = -307
    uDescriptor.FontRectRight = 1401
    uDescriptor.FontRectBottom = 1033
    uDescriptor.FontItalicAngle = -16.333
    uDescriptor.FontStemV = 135
    uDescriptor.FontWeight = 700
    uDescriptor.FontUnderlineThickness = 73
    uDescriptor.FontUnderlinePosition = -180

' Add to font list

    sFontKey = "F" + STR(UBOUND(arFontID) + 1)
    uFont.sFontID = sFontKey
    uFont.uFont = uDescriptor
    AppendElementToArray(arFontID, uFont)

' Add the character widths

   sWidthList = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,389,555,500,500,833,777,277,333,333,500,569,250,333,250,277," _
      + "500,500,500,500,500,500,500,500,500,500,333,333,569,569,569,500," _
      + "832,666,666,666,722,666,666,722,777,389,500,666,610,889,722,722," _
      + "610,722,666,556,610,722,666,889,666,610,610,333,277,333,569,500," _
      + "333,500,500,443,500,443,333,500,556,277,277,500,277,777,556,500," _
      + "500,500,389,389,277,556,443,666,500,443,389,348,220,348,569,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0," _
      + "250,389,500,500,500,500,220,500,333,747,266,500,605,333,747,500," _
      + "399,548,299,299,333,576,500,250,333,299,299,500,750,750,750,500 ," _
      + "666,666,666,666,666,666,943,666,666,666,666,666,389,389,389,389," _
      + "722,722,722,722,722,722,722,569,722,722,722,722,722,610,610,500," _
      + "500,500,500,500,500,500,722,443,443,443,443,443,277,277,277,277," _
      + "500,556,500,500,500,500,500,548,500,556,556,556,556,443,500,443,"

    uWidths.sFontID = sFontKey
    uWidths.sFontWidths = sWidthList
    AppendElementToArray(arFontWidths, uWidths)

End Sub
