#cmdline "-s console"   ' console application
#DEFINE UNICODE
#DEFINE _WIN32_WINNT &h0602
#INCLUDE ONCE "crInc\cPDF\cPDF.bi"
#INCLUDE ONCE "AfxNova\RGB_Colors.bi"
#INCLUDE ONCE "AfxNova\AfxTime.inc"
#INCLUDE ONCE "String.bi"
#INCLUDE ONCE "AfxNova\AfxArrays.inc"
#INCLUDE ONCE "AfxNova\AfxSort.inc"

DIM ocPDF             AS cPDF
DIM sFontID           AS DWSTRING
DIM sFontIDBold       AS DWSTRING
DIM sString           AS DWSTRING
DIM sLine             AS DWSTRING
DIM sDocument         AS STRING = "PDFDemo.pdf"
DIM sReportData       AS DWSTRING
DIM sImageID          AS DWSTRING
DIM uLocalTime        AS SYSTEMTIME
DIM uLine             AS LineDescriptor
DIM uTextDescriptor   AS TextDescriptor
DIM uImage            AS ImageOptions
DIM uMulti            AS MultiLineTextDescriptor
DIM uRectangle        AS RectangleDescriptor
DIM uImageAttributes  AS ImageAttributes
DIM uMetrics          AS PageMetrics
DIM CRLF              AS DWSTRING = CHR(13, 10)
DIM nStringSize       AS DOUBLE
DIM nY                AS DOUBLE
DIM nX                AS DOUBLE
DIM n2010Total        AS LONG
DIM n2011Total        AS LONG
DIM n2012Total        AS LONG
DIM n2010RegionTotal  AS LONG
DIM n2011RegionTotal  AS LONG
DIM n2012RegionTotal  AS LONG
DIM n2010StateTotal   AS LONG
DIM n2011StateTotal   AS LONG
DIM n2012StateTotal   AS LONG
DIM nLineHeight       AS DOUBLE
DIM arReportData(ANY) AS DWSTRING
DIM nStart            AS LONG
DIM nIndex            AS LONG
DIM sTemplateID       AS DWSTRING
DIM uMainMargins      AS RECT
DIM arRows()          AS ReportRow
DIM uReportRow        AS ReportRow
DIM bAscending        AS BOOLEAN = True
DIM sRowSort          AS DWSTRING
DIM sPreviousRegion   AS DWSTRING = ""

' Windows system wide fonts can be found in "c:\windows\fonts\

' Adobe Acrobat has width issues with these embedded fonts

'   ocPDF.PDFEmbedFont(FONT_VERDANA,PDF_FONT_NORMAL,"verdana.ttf")
'   ocPDF.PDFEmbedFont(FONT_VERDANA,PDF_FONT_BOLD,"verdanab.ttf")
'   ocPDF.PDFEmbedFont(FONT_ARIAL,PDF_FONT_NORMAL,"arial.ttf")
'   ocPDF.PDFEmbedFont(FONT_ARIAL,PDF_FONT_BOLD,"arialbd.ttf") 
'   ocPDF.PDFEmbedFont(FONT_TREBUCHET,PDF_FONT_NORMAL,"trebuc.ttf") 
'   ocPDF.PDFEmbedFont(FONT_TREBUCHET,PDF_FONT_BOLD,"trebucbd.ttf")
'   ocPDF.PDFEmbedFont(FONT_CALIBRI,PDF_FONT_NORMAL,"calibri.ttf")
'   ocPDF.PDFEmbedFont(FONT_CALIBRI,PDF_FONT_BOLD,"calibrib.ttf")
'   ocPDF.PDFEmbedFont(FONT_CONSOLAS,PDF_FONT_NORMAL,"consola.ttf")
'   ocPDF.PDFEmbedFont(FONT_CONSOLAS,PDF_FONT_BOLD,"consolab.ttf")
'   ocPDF.PDFEmbedFont(FONT_TIMESNEWROMAN,PDF_FONT_NORMAL,"times.ttf")
'   ocPDF.PDFEmbedFont(FONT_TIMESNEWROMAN,PDF_FONT_BOLD,"timesbd.ttf")

   ocPDF.PDFViewerPreferences(1,0,0,1,0,0,0)
   ocPDF.PDFSetTitle("cPDF Class Examples")
   ocPDF.PDFSetPaperSize(PDF_PAPER_LETTER)
   ocPDF.PDFSetPaperOrientation(PDFPAGE_PORTRAIT)
   ocPDF.PDFSetPaperTopMargin(PDF_ONE_QUARTER_INCH)
   ocPDF.PDFSetPaperBottomMargin(PDF_ONE_QUARTER_INCH)
   ocPDF.PDFSetPaperLeftMargin(PDF_ONE_QUARTER_INCH)
   ocPDF.PDFSetPaperRightMargin(PDF_ONE_QUARTER_INCH)
   ocPDF.PDFCurrentPageMetrics(uMetrics)
   
   ocPDF.PDFCreateDocument()
   
   sFontID = ocPDF.PDFFont(FONT_CONSOLAS,PDF_FONT_NORMAL)
   
 ' Other Objects to include on every page, must be defined AFTER PDFCreateDocument
 
   sString = "Credits: Tiko Editor at https://github.com/PaulSquires/tiko and AFXNova at: https://github.com/JoseRoca/AfxNova"
   uTextDescriptor.FontSize = 9
   uTextDescriptor.FontColor = RGB_DARKGRAY
   uTextDescriptor.Justify = TEXT_JUSTIFY_LEFT
   ocPDF.PDFPlaceHolderTextCreate (uMetrics.LeftMargin + 1,uMetrics.DrawingHeight - 2,uTextDescriptor,"credits",sString)
   uTextDescriptor.Justify = ITEM_IGNORE  

   uLine.Color = RGB_DARKGRAY
   uLine.Width = 1
   uLine.Cap = PDF_LINECAP_ROUND
   uLine.Join = ITEM_IGNORE
   uLine.Miter = ITEM_IGNORE
   uLine.Dash.Array1 = ""
   uLine.Dash.Phase = 0
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 9)
   ocPDF.PDFPlaceHolderLineCreate(uMetrics.LeftMargin,uMetrics.DrawingHeight - nLineHeight - 2,uMetrics.DrawingWidth - 11,uMetrics.DrawingHeight - nLineHeight - 1,uLine,"footerline")
   
 ' Use Placeholder to number the pages

   sFontID = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_NORMAL) 
   sString = "[Page %pageno of %totalpages]"
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12)
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.FontID = sFontID
   ocPDF.PDFPlaceHolderTextCreate (uMetrics.Width - ocPDF.PDFMeasureString(sFontID,sString,12) + uMetrics.RightMargin + uMetrics.LeftMargin, _
                                   uMetrics.RightMargin + 5,uTextDescriptor,"pagenumber",sString)

' Other Header items to include on every page

   sString = "cPDF Class Examples" 
   uTextDescriptor.FontSize = 14
   ocPDF.PDFPlaceHolderTextCreate ((uMetrics.Width / 2) - ((ocPDF.PDFMeasureString(sFontID,sString,14) / 2)), _
                                   uMetrics.RightMargin + 5,uTextDescriptor,"pageheader",sString)   

   uLocalTime = AfxLocalSystemTime()
   sString = FORMAT(uLocalTime.wYear,"0000") _
           + "." _
           + FORMAT(uLocalTime.wMonth,"00") _
           + "." _
           + FORMAT(uLocalTime.wDay,"00") _
           + " " _
           + FORMAT(uLocalTime.wHour,"00") _
           + ":" _
           + FORMAT(uLocalTime.wMinute,"00") _
           + ":" _
           + FORMAT(uLocalTime.wSecond,"00") 
   uTextDescriptor.FontSize = 12
   ocPDF.PDFPlaceHolderTextCreate (uMetrics.LeftMargin + 5,uMetrics.TopMargin + 5,uTextDescriptor,"currentdate",sString)          
           
' Insert Place Holders into page streams
 
   ocPDF.PDFInsertPlaceHolders()  

   ocPDF.PDFAddOutlineSection("Fonts")  
 
   uTextDescriptor.Justify = TEXT_JUSTIFY_RIGHT
   uTextDescriptor.Underline = FONT_UNDERLINE
   uTextDescriptor.LineDescriptor.Color = RGB_BLACK 'ITEM_IGNORE
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE 'PDF_LINECAP_BUTT
   uTextDescriptor.LineDescriptor.Join = ITEM_IGNORE 'PDF_LINEJOIN_ROUND
   uTextDescriptor.LineDescriptor.Miter = ITEM_IGNORE
   uTextDescriptor.LineDescriptor.Dash.Array1 = ""
   uTextDescriptor.LineDescriptor.Dash.Phase = 0

   uRectangle.Height = nLineHeight * 10
   uRectangle.Width = 400
   uRectangle.FillColor = RGB_CORNSILK
   uRectangle.Radius = ITEM_IGNORE
   uRectangle.LineAttributes.Color = RGB_LIGHTGRAY
   uRectangle.LineAttributes.Width = 1
   uRectangle.LineAttributes.Cap = ITEM_IGNORE
   uRectangle.LineAttributes.Join = ITEM_IGNORE
   uRectangle.LineAttributes.Miter = ITEM_IGNORE
   uRectangle.LineAttributes.Dash.Array1 = ""
   uRectangle.LineAttributes.Dash.Phase = 0

   ocPDF.PDFRectangle((uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2), 50, uRectangle)
   sFontID = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_NORMAL)
   sFontIDBold = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_BOLD)     
   nY = 50 + nLineHeight
   sLine = "Arial 12 pt Normal."
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.Justify = ITEM_IGNORE
   uTextDescriptor.UnderLine = ITEM_IGNORE
   nX = (uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2) + 4
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
 
   sLine = "Arial 12 pt Normal with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Arial 12 pt Normal with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Arial 12 pt Normal with underlining."
   nStringSize = ocPDF.PDFMeasureString(sFontID,sLine,12)
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.Underline = FONT_UNDERLINE
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
        
   sLine = "Arial 12 pt Bold."
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   uTextDescriptor.Underline = ITEM_IGNORE
   uTextDescriptor.FontID = sFontIDBold
   nY = nY + nLineHeight + 5
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Arial 12 pt Bold with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Arial 12 pt Bold with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 14) 
   sLine = "Arial 9 pt Normal."
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 9
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Arial 14 pt Normal."
   uTextDescriptor.FontSize = 14
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sFontID = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_NORMAL)
   uTextDescriptor.FontID = sFontID
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12)
   uTextDescriptor.Justify = TEXT_JUSTIFY_CENTER
   sLine = "Using Rounded Rectangles"
   nStringSize = ocPDF.PDFMeasureString(sFontID,sLine,12)
   uTextDescriptor.FontSize = 12
   nY = nY + (nLineHeight * 3)
   ocPDF.PDFWriteText ((uMetrics.DrawingWidth / 2),nY,uTextDescriptor,sLine)
   nY = nY + (nLineHeight * 2) 
   
   sFontID = ocPDF.PDFFont(FONT_TIMESNEWROMAN,PDF_FONT_NORMAL)
   sFontIDBold = ocPDF.PDFFont(FONT_TIMESNEWROMAN,PDF_FONT_BOLD)   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12) 
   uRectangle.FillColor = RGB_WHEAT
   uRectangle.Radius = 10
   uRectangle.Height = nLineHeight * 10
   ocPDF.PDFRectangle((uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2), nY, uRectangle) 
 
   nY = nY + nLineHeight
   sLine = "Times New Roman 12 pt."
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.Justify = ITEM_IGNORE
   uTextDescriptor.UnderLine = ITEM_IGNORE
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sLine = "Times New Roman 12 pt with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Times New Roman 12 pt with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Times New Roman 12 pt with underlining."
   nStringSize = ocPDF.PDFMeasureString(sFontID,sLine,12)
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.Underline = FONT_UNDERLINE
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
        
   sLine = "Times New Roman 12 pt."
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   uTextDescriptor.Underline = ITEM_IGNORE
   uTextDescriptor.FontID = sFontIDBold
   nY = nY + nLineHeight + 5
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Times New Roman Bold 12 pt with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Times New Roman Bold 12 pt with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 14) 
   sLine = "Times New Roman 9 pt."
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 9
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Times New Roman 14 pt."
   uTextDescriptor.FontSize = 14
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12) 
   nY = nY + nLineHeight * 2
   uRectangle.FillColor = RGB_PEACHPUFF
   uRectangle.Height = nLineHeight * 13
   ocPDF.PDFRectangle((uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2), nY, uRectangle)
   
   sFontID = ocPDF.PDFFont(FONT_VERDANA,PDF_FONT_NORMAL)
   sFontIDBold = ocPDF.PDFFont(FONT_VERDANA,PDF_FONT_BOLD)
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12)
   nY = nY + nLineHeight + (nLineHeight * .5)
   
   sLine = "Verdana 12 pt Normal."
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.Justify = ITEM_IGNORE
   uTextDescriptor.UnderLine = ITEM_IGNORE
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sLine = "Verdana 12 pt Normal with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Verdana 12 pt Normal with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Verdana 12 pt Normal with underlining."
   nStringSize = ocPDF.PDFMeasureString(sFontID,sLine,12)
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.Underline = FONT_UNDERLINE
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontIDBold, 12)     
   sLine = "Verdana 12 pt Bold."
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   uTextDescriptor.Underline = ITEM_IGNORE
   uTextDescriptor.FontID = sFontIDBold
   nY = nY + nLineHeight + 5
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Verdana 12 pt Bold with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Verdana 12 pt Bold with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 14) 
   sLine = "Verdana 9 pt Normal."
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 9
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Verdana 14 pt Normal."
   uTextDescriptor.FontSize = 14
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)              
   
   nY = nY + nLineHeight * 2
   uRectangle.FillColor = RGB_PAPAYAWHIP
   ocPDF.PDFRectangle((uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2), nY, uRectangle)
   
   sFontID = ocPDF.PDFFont(FONT_TREBUCHET,PDF_FONT_NORMAL)
   sFontIDBold = ocPDF.PDFFont(FONT_TREBUCHET,PDF_FONT_BOLD)
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12)
   nY = nY + nLineHeight * 2
   
   sLine = "Trebuchet 12 pt Normal."
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.Justify = ITEM_IGNORE
   uTextDescriptor.UnderLine = ITEM_IGNORE
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sLine = "Trebuchet 12 pt Normal with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontIDBold, 12)    
   sLine = "Trebuchet 12 pt Normal with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sLine = "Trebuchet 12 pt Normal with underlining."
   nStringSize = ocPDF.PDFMeasureString(sFontID,sLine,12)
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.Underline = FONT_UNDERLINE
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
        
   sLine = "Trebuchet 12 pt Bold."
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   uTextDescriptor.Underline = ITEM_IGNORE
   uTextDescriptor.FontID = sFontIDBold
   nY = nY + nLineHeight + 5
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Trebuchet 12 pt Bold with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Trebuchet 12 pt Bold with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 14) 
   sLine = "Trebuchet 9 pt Normal."
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 9
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Trebuchet 14 pt Normal."
   uTextDescriptor.FontSize = 14
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)   
   
   ocPDF.PDFEndPage()
   oCPDF.PDFNewPage()
   
   ocPDF.PDFAddOutlineSubSection("More Fonts")    

   sFontID = ocPDF.PDFFont(FONT_CALIBRI,PDF_FONT_NORMAL)
   sFontIDBold = ocPDF.PDFFont(FONT_CALIBRI,PDF_FONT_BOLD)
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 14) 
   
   uRectangle.Height = nLineHeight * 11             ' Room for 9 lines plus empty space at top and bottom
   uRectangle.Width = 440
   uRectangle.FillColor = RGB_PAPAYAWHIP
   uRectangle.Radius = ITEM_IGNORE
   uRectangle.LineAttributes.Color = RGB_LIGHTGRAY
   uRectangle.LineAttributes.Width = 1
   uRectangle.LineAttributes.Cap = ITEM_IGNORE
   uRectangle.LineAttributes.Join = ITEM_IGNORE
   uRectangle.LineAttributes.Miter = ITEM_IGNORE
   uRectangle.LineAttributes.Dash.Array1 = ""
   uRectangle.LineAttributes.Dash.Phase = 0
   
   ocPDF.PDFRectangle((uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2), 50, uRectangle)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12) 
   nY = 50 + nLineHeight * 2
   nX = (uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2) + 4

   sLine = "Calibri 12 pt Normal."
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.Justify = ITEM_IGNORE
   uTextDescriptor.UnderLine = ITEM_IGNORE
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
 
   sLine = "Calibri 12 pt Normal with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Calibri 12 pt Normal with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Calibri 12 pt Normal with underlining."
   nStringSize = ocPDF.PDFMeasureString(sFontID,sLine,12)
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.Underline = FONT_UNDERLINE
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   nLineHeight = ocPDF.PDFLineHeight(sFontIDBold, 12) 
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sLine = "Calibri 12 pt Bold."
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   uTextDescriptor.Underline = ITEM_IGNORE
   uTextDescriptor.FontID = sFontIDBold
   nY = nY + nLineHeight + 5
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Calibri 12 pt Bold with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Calibri 12 pt Bold with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 14)  
   sLine = "Calibri 9 pt Normal."
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 9
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Calibri 14 pt Normal."
   uTextDescriptor.FontSize = 14
   nY = nY + ocPDF.PDFLineHeight(sFontID, 14)
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine) 
   
   nY = nY + nLineHeight * 1.65
   uRectangle.FillColor = RGB_CORNSILK
   ocPDF.PDFRectangle((uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2), nY, uRectangle)
   
   sFontID = ocPDF.PDFFont(FONT_CONSOLAS,PDF_FONT_NORMAL)
   sFontIDBold = ocPDF.PDFFont(FONT_CONSOLAS,PDF_FONT_BOLD)
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12)
   nY = nY + nLineHeight * 2
   nX = (uMetrics.DrawingWidth / 2) - (uRectangle.Width / 2) + 4
   sLine = "Consolas 12 pt Normal."
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.Justify = ITEM_IGNORE
   uTextDescriptor.UnderLine = ITEM_IGNORE
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sLine = "Consolas 12 pt Normal with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Consolas 12 pt Normal with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Consolas 12 pt Normal with underlining."
   nStringSize = ocPDF.PDFMeasureString(sFontID,sLine,12)
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.Underline = FONT_UNDERLINE
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   nLineHeight = ocPDF.PDFLineHeight(sFontIDBold, 12) 
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   sLine = "Consolas 12 pt Bold."
   uTextDescriptor.Underline = ITEM_IGNORE
   uTextDescriptor.FontID = sFontIDBold
   nY = nY + nLineHeight + 5
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Consolas 12 pt Bold with word spacing set to 2.5."
   uTextDescriptor.WordSpacing = 2.5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Consolas 12 pt Bold with character spacing set to .5."
   uTextDescriptor.WordSpacing = 0
   uTextDescriptor.CharSpacing = .5
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 14)  
   sLine = "Consolas 9 pt Normal."
   uTextDescriptor.CharSpacing = 0
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 9
   nY = nY + nLineHeight
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine)
    
   sLine = "Consolas 14 pt Normal."
   uTextDescriptor.FontSize = 14
   nY = nY + ocPDF.PDFLineHeight(sFontID, 14)
   ocPDF.PDFWriteText (nX,nY,uTextDescriptor,sLine) 
   
   oCPDF.PDFEndPage()
   ocPDF.PDFNewPage()
   
   ocPDF.PDFAddOutlineSection("Shapes and Images") 
   sFontID = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_NORMAL)
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 14
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.Angle = ITEM_IGNORE
   uTextDescriptor.Justify = TEXT_JUSTIFY_CENTER
   uTextDescriptor.Underline = ITEM_IGNORE
   uTextDescriptor.LineDescriptor.Color = ITEM_IGNORE
   uTextDescriptor.LineDescriptor.Cap = ITEM_IGNORE
   uTextDescriptor.LineDescriptor.Join = ITEM_IGNORE
   uTextDescriptor.LineDescriptor.Miter = ITEM_IGNORE
   uTextDescriptor.LineDescriptor.Dash.Array1 = ""
   uTextDescriptor.LineDescriptor.Dash.Phase = 0 
   sString = "Shapes and Images"
   ocPDF.PDFWriteText ((uMetrics.DrawingWidth / 2),50,uTextDescriptor,sString) 
   uTextDescriptor.Justify = TEXT_JUSTIFY_LEFT
   uTextDescriptor.FontSize = 12 
   uLine.Color = RGB_LIGHTGRAY
   uLine.Width = 1
   uLine.Cap = ITEM_IGNORE
   uLine.Join = ITEM_IGNORE
   uLine.Miter = ITEM_IGNORE
   uLine.Dash.Array1 = ""
   uLine.Dash.Phase = 0  
   ocPDF.PDFEllispe(190,200,80,80,RGB_BLACK,RGB_WHITE)
   ocPDF.PDFEllispe(300,200,40,100,RGB_LIGHTSLATEGRAY,RGB_LIGHTSLATEGRAY)
   ocPDF.PDFEllispe(410,200,100,30,RGB_CYAN,RGB_CYAN)
   ocPDF.PDFRegularPolygon(80,310,50,9,ITEM_IGNORE,uLine)
   ocPDF.PDFRegularPolygon(190,310,50,8,ITEM_IGNORE,uLine)
   ocPDF.PDFRegularPolygon(300,310,50,7,ITEM_IGNORE,uLine)
   ocPDF.PDFRegularPolygon(410,310,50,6,ITEM_IGNORE,uLine)
      
   oCPDF.AddImageJPEG("Garden.jpg",sImageID)
   oCPDF.PDFImageAttributes(sImageID,uImageAttributes)
   oCPDF.PDFWriteImage(sImageID,0,500,uImage)
   uImage.ScalingPercent = .75
   oCPDF.PDFWriteImage(sImageID,200,500,uImage)
   uImage.ScalingPercent = .50
   oCPDF.PDFWriteImage(sImageID,350,500,uImage)
   oCPDF.PDFWriteText(0,520,uTextDescriptor,"Jpeg picture shown at full size (" + _
                                           FORMAT(uImageAttributes.ImagePixelHeight) + " x " + _
                                           FORMAT(uImageAttributes.ImagePixelWidth) + ") " + _
                                           "and then scaled at 75% and 50%.")
  
   ocPDF.PDFEndPage()
   oCPDF.PDFNewPage() 
   
   ocPDF.PDFAddOutlineSection("Report Using a Template") 
   
   sFontID = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_NORMAL)
   sFontIDBold = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_BOLD) 
   nLineHeight = ocPDF.PDFLineHeight(sFontIDBold, 12)
   uRectangle.Height = uMetrics.DrawingHeight - 70           
   uRectangle.Width = 579
   uRectangle.FillColor = ITEM_IGNORE
   uRectangle.Radius = 0
   uRectangle.LineAttributes.Color = RGB_WHITE
   uRectangle.LineAttributes.Width = .5
   uRectangle.LineAttributes.Cap = ITEM_IGNORE
   uRectangle.LineAttributes.Join = ITEM_IGNORE
   uRectangle.LineAttributes.Miter = ITEM_IGNORE
   uRectangle.LineAttributes.Dash.Array1 = ""
   uRectangle.LineAttributes.Dash.Phase = 0 
   uMainMargins.bottom = 4
   uMainMargins.top = 4
   uMainMargins.left = 4
   uMainMargins.right = 4
   sTemplateID = ocPDF.PDFCreateReportTemplate(50,50,TEXT_JUSTIFY_CENTER,uMainMargins,uRectangle)
   uRectangle.LineAttributes.Color = RGB_LIGHTGRAY
   uRectangle.Height = 60
   uRectangle.FillColor = &HBDD2F2  'Bisque
   ocPDF.PDFCreateReportHeaderTemplate(sTemplateID,uMainMargins,uRectangle)
   uRectangle.FillColor = RGB_WHITE
   uRectangle.Height = nLineHeight * 3
   ocPDF.PDFCreateReportColumnHeaderTemplate(sTemplateID,uMainMargins,uRectangle)
   uTextDescriptor.FontID = sFontIDBold
   uTextDescriptor.FontSize = 12
   uTextDescriptor.FontColor = RGB_BLACK
   uTextDescriptor.Angle = ITEM_IGNORE
   uTextDescriptor.Justify = TEXT_JUSTIFY_CENTER
   uTextDescriptor.Underline = ITEM_IGNORE
   uRectangle.FillColor = &HFFFFF0  'Azure
   uRectangle.Width = 75
   ocPDF.PDFAddReportColumns(sTemplateID,uMainMargins,"Region",uRectangle,uTextDescriptor,TEXT_VERTICAL_CENTER,ITEM_IGNORE,RGB_WHITESMOKE)   
   uRectangle.Width = 200
   ocPDF.PDFAddReportColumns(sTemplateID,uMainMargins,"State",uRectangle,uTextDescriptor,TEXT_VERTICAL_CENTER,ITEM_IGNORE,RGB_WHITESMOKE)
   uRectangle.Width = 75
   ocPDF.PDFAddReportColumns(sTemplateID,uMainMargins,"2010",uRectangle,uTextDescriptor,TEXT_VERTICAL_CENTER,ITEM_IGNORE,RGB_WHITESMOKE)
   uRectangle.Width = 75   
   ocPDF.PDFAddReportColumns(sTemplateID,uMainMargins,"2011",uRectangle,uTextDescriptor,TEXT_VERTICAL_CENTER,ITEM_IGNORE,RGB_WHITESMOKE)
   uRectangle.Width = 75   
   ocPDF.PDFAddReportColumns(sTemplateID,uMainMargins,"2012",uRectangle,uTextDescriptor,TEXT_VERTICAL_CENTER,ITEM_IGNORE,RGB_WHITESMOKE)
   uRectangle.Width = 70
   ocPDF.PDFAddReportColumns(sTemplateID,uMainMargins,"% Change",uRectangle,uTextDescriptor,TEXT_VERTICAL_CENTER,ITEM_IGNORE,RGB_WHITESMOKE)   
   uRectangle.FillColor = RGB_WHITE
   uTextDescriptor.FontSize = 14
   ocPDF.PDFAddHeaderText(sTemplateID,0,5,uTextDescriptor,"Sample Report using U.S. Population Estimates (as of July 1)") 
   uTextDescriptor.FontSize = 12  
   
   nLineHeight = ocPDF.PDFLineHeight(sFontID, 12)
   uTextDescriptor.FontID = sFontID
   uReportRow.VerticalAlignment = TEXT_VERTICAL_CENTER
   uReportRow.Height = nLineHeight * 2
   uReportRow.Margins = uMainMargins
   
   sReportData = ",South,Alabama,4784762,4803689,4822023,West,Alaska,714046,723860,731449,West,Arizona,6410810,6467315,6553255" _
               + ",South,Arkansas,2922750,2938582,2949131,West,California,37334410,37683933,38041430,West,Colorado,5048472,5116302,5187582" _
               + ",Northeast,Connecticut,3576616,3586717,3590347,South,Delaware,899824,908137,917092,South,Washington DC,604989,619020,632323" _
               + ",South,Florida,18845967,19082262,19317568,South,Georgia,9714748,9812460,9919945,West,Hawaii,1364274,1378129,1392313" _
               + ",West,Idaho,1570784,1583744,1595728,Midwest,Illinois,12840459,12859752,12875255,Midwest,Indiana,6489856,6516353,6537334" _
               + ",Midwest,Iowa,3050321,3064097,3074186,Midwest,Kansas,2858837,2870386,2885905,South,Kentucky,4346655,4366814,4380415" _
               + ",South,Louisiana,4544125,4574766,4601893,Northeast,Maine,1327585,1328544,1329192,South,Maryland,5787998,5839572,5884563" _
               + ",Northeast,Massachusetts,6563259,6607003,6646144,Midwest,Michigan,9877670,9876801,9883360,Midwest,Minnesota,5310737,5347299,5379139" _
               + ",South,Mississippi,2969137,2977457,2984926,Midwest,Missouri,5996092,6008984,6021988,West,Montana,990735,997667,1005141" _
               + ",Midwest,Nebraska,1829696,1842234,1855525,West,Nevada,2703758,2720028,2758931,Northeast,New Hampshire,1316843,1317807,1320718" _
               + ",Northeast,New Jersey,8803388,8834773,8864590,West,New Mexico,2064767,2078674,2085538,Northeast,New York,19399242,19501616,19570261" _
               + ",South,North Carolina,9559048,9651103,9752073,Midwest,North Dakota,674363,684740,699628,Midwest,Ohio,11538290,11541007,11544225" _
               + ",South,Oklahoma,3759482,3784163,3814820,West,Oregon,3838212,3868229,3899353,Northeast,Pennsylvania,12711308,12743948,12763536" _
               + ",Caribbean,Puerto Rico,3721208,3694093,3667084,Northeast,Rhode Island,1052769,1050646,1050292,South,South Carolina,4635835,4673348,4723723" _
               + ",Midwest,South Dakota,816223,823593,833354,South,Tennessee,6356673,6399787,6456243,South,Texas,25242683,25631778,26059203" _
               + ",West,Utah,2775093,2814347,2855287,Northeast,Vermont,625916,626592,626011,South,Virginia,8025105,8104384,8185867" _
               + ",West,Washington,6743636,6823267,6897012,South,West Virginia,1854019,1854908,1855413,Midwest,Wisconsin,5689591,5709843,5726398" _
               + ",West,Wyoming,564367,567356,576412," 
               
   nStart = 1
   WHILE nStart < LEN(sReportData)
      sRowSort = ","
      sString = AfxStrExtract(nStart,sReportData,",",",")
      sRowSort = sRowSort + sString + ","
      nStart = nStart + LEN(sString) + 1
      sString = AfxStrExtract(nStart,sReportData,",",",")
      sRowSort = sRowSort + sString + "," 
      nStart = nStart + LEN(sString) + 1
      sString = AfxStrExtract(nStart,sReportData,",",",")
      sRowSort = sRowSort + sString + "," 
      nStart = nStart + LEN(sString) + 1
      sString = AfxStrExtract(nStart,sReportData,",",",")
      sRowSort = sRowSort + sString + "," 
      nStart = nStart + LEN(sString) + 1
      sString = AfxStrExtract(nStart,sReportData,",",",")
      sRowSort = sRowSort + sString + "," 
      nStart = nStart + LEN(sString) + 1                          
      AppendElementToArray(arReportData,sRowSort)
   WEND 
   
 ' Sort by Region and State                 

   AfxSortStringArray(arReportData,bAscending)
   
   For nIndex = LBOUND(arReportData) TO UBOUND(arReportData)

' Region      

      nStart = 1      
      sString = AfxStrExtract(nStart,arReportData(nIndex),",",",")
      
      If sPreviousRegion = "" Then
          
         sPreviousRegion = sString 
         
      Else
          
          If sPreviousRegion <> sString Then
          
' Region Subtotals 

             uReportRow.StringID = ocPDF.CreateStringID(" ")
             uTextDescriptor.Justify = TEXT_JUSTIFY_RIGHT
             uTextDescriptor.FontID = sFontIDBold 
             uReportRow.TextDescriptor = uTextDescriptor         
             AppendElementToArray(arRows,uReportRow)
             uReportRow.StringID = ocPDF.CreateStringID("Region Totals")
             AppendElementToArray(arRows,uReportRow)
             uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2010RegionTotal,"###,###,###")))
             AppendElementToArray(arRows,uReportRow)
             uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2011RegionTotal,"###,###,###")))
             AppendElementToArray(arRows,uReportRow)
             uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2012RegionTotal,"###,###,###")))
             AppendElementToArray(arRows,uReportRow)
             uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(((n2012RegionTotal - n2010RegionTotal) / n2010RegionTotal) * 100,"###.0000")))
             AppendElementToArray(arRows,uReportRow)          
             sPreviousRegion = sString 
             n2010RegionTotal = 0
             n2011RegionTotal = 0
             n2012RegionTotal = 0
             uTextDescriptor.FontID = sFontID
                                               
          
          End If
             
      End If
      
      uReportRow.StringID = ocPDF.CreateStringID(sString)
      uTextDescriptor.Justify = TEXT_JUSTIFY_LEFT
      uReportRow.TextDescriptor = uTextDescriptor
      AppendElementToArray(arRows,uReportRow)       
  
' State     

      nStart = nStart + LEN(sString) + 1      
      sString = AfxStrExtract(nStart,arReportData(nIndex),",",",")
      uReportRow.StringID = ocPDF.CreateStringID(sString)
      AppendElementToArray(arRows,uReportRow) 
      
' 2010 Population Estimate     

      nStart = nStart + LEN(sString) + 1      
      sString = AfxStrExtract(nStart,arReportData(nIndex),",",",")
      n2010StateTotal = VAL(sString)
      uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2010StateTotal,"###,###,###")))
      n2010Total = n2010Total + VAL(sString)
      n2010RegionTotal = n2010RegionTotal + VAL(sString)
      uTextDescriptor.Justify = TEXT_JUSTIFY_RIGHT
      uReportRow.TextDescriptor = uTextDescriptor
      AppendElementToArray(arRows,uReportRow)
      
' 2011 Population Estimate     

      nStart = nStart + LEN(sString) + 1      
      sString = AfxStrExtract(nStart,arReportData(nIndex),",",",")
      n2011StateTotal = VAL(sString)
      uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2011StateTotal,"###,###,###")))
      n2011Total = n2011Total + VAL(sString)
      n2011RegionTotal = n2011RegionTotal + VAL(sString)
      AppendElementToArray(arRows,uReportRow)
      
' 2012 Population Estimate     

      nStart = nStart + LEN(sString) + 1      
      sString = AfxStrExtract(nStart,arReportData(nIndex),",",",")
      n2012StateTotal = VAL(sString)
      uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2012StateTotal,"###,###,###")))      
      n2012Total = n2012Total + VAL(sString)
      n2012RegionTotal = n2012RegionTotal + VAL(sString)
      AppendElementToArray(arRows,uReportRow) 
      
' % Population Change

      uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(((n2012StateTotal - n2010StateTotal) / n2010StateTotal) * 100,"###.0000")))
      AppendElementToArray(arRows,uReportRow)                       
        
   Next

   
   uTextDescriptor.FontID = sFontIDBold 
   uReportRow.TextDescriptor = uTextDescriptor
   
' Last Region Subtotals 

   uReportRow.StringID = ocPDF.CreateStringID(" ")
   uTextDescriptor.Justify = TEXT_JUSTIFY_RIGHT
   uTextDescriptor.FontID = sFontIDBold 
   uReportRow.TextDescriptor = uTextDescriptor         
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID("Region Totals")
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2010RegionTotal,"###,###,###")))
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2011RegionTotal,"###,###,###")))
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2012RegionTotal,"###,###,###")))
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(((n2012RegionTotal - n2010RegionTotal) / n2010RegionTotal) * 100,"###.0000")))
   AppendElementToArray(arRows,uReportRow)    
      
   ' Insert a blank row before totals

   uReportRow.StringID = ocPDF.CreateStringID(" ")   
   AppendElementToArray(arRows,uReportRow)
   AppendElementToArray(arRows,uReportRow)
   AppendElementToArray(arRows,uReportRow)
   AppendElementToArray(arRows,uReportRow)
   AppendElementToArray(arRows,uReportRow)
   AppendElementToArray(arRows,uReportRow)

   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID("Final Totals")
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2010Total,"###,###,###")))
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2011Total,"###,###,###")))
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(n2012Total,"###,###,###")))
   AppendElementToArray(arRows,uReportRow)
   uReportRow.StringID = ocPDF.CreateStringID(TRIM(FORMAT(((n2012Total - n2010Total) / n2010Total) * 100,"###.0000")))
   AppendElementToArray(arRows,uReportRow)
   
   ' Create the report      
 
   ocPDF.PDFDrawRows(sTemplateID,arRows())   

   
 ' Define some additional Place Holders for next page
 
   uRectangle.Height = 100             
   uRectangle.Width = 100
   uRectangle.FillColor = RGB_WHITE
   uRectangle.Radius = ITEM_IGNORE
   uRectangle.LineAttributes.Color = RGB_LIGHTGRAY
   uRectangle.LineAttributes.Width = 1
   uRectangle.Radius = 10
   uRectangle.LineAttributes.Cap = ITEM_IGNORE
   uRectangle.LineAttributes.Join = ITEM_IGNORE
   uRectangle.LineAttributes.Miter = ITEM_IGNORE
   uRectangle.LineAttributes.Dash.Array1 = ""
   uRectangle.LineAttributes.Dash.Phase = 0 
   ocPDF.PDFPlaceHolderRectangleCreate (50,80,uRectangle,"rectangle") 
   ocPDF.PDFPlaceHolderEllispeCreate(200,130,80,80,RGB_BLACK,RGB_WHITE,"ellispe")
   ocPDF.PDFPlaceHolderRegularPolygonCreate(300,130,50,8,ITEM_IGNORE,uLine,"polygon")
   ocPDF.PDFPlaceHolderWriteImageCreate(sImageID,360,160,uImage,"image")
   uMulti.TextAttributes.FontID = sFontID
   uMulti.TextAttributes.FontSize = 12
   uMulti.TextAttributes.Justify = TEXT_JUSTIFY_LEFT
   uMulti.TextAttributes.Angle = ITEM_IGNORE
   uMulti.TextAttributes.FontColor = RGB_DARKSLATEGRAY
   uMulti.Width = 100
   sString = "Multi Line 1" + CRLF + "Multi Line 2" + CRLF + "Multi Line 3" 
   ocPDF.PDFPlaceHolderMultiLineCreate(50,200,uMulti,sString,"multiline")     
    
   ocPDF.PDFEndPage()    
   
   oCPDF.PDFNewPage()
   
   ocPDF.PDFAddOutlineSection("Other PlaceHolder Objects")
   sFontID = ocPDF.PDFFont(FONT_ARIAL,PDF_FONT_NORMAL)
   uTextDescriptor.FontID = sFontID
   uTextDescriptor.FontSize = 14
   uTextDescriptor.Justify = TEXT_JUSTIFY_CENTER
   sString = "Other Placeholder Types"
   ocPDF.PDFWriteText ((uMetrics.DrawingWidth / 2),50,uTextDescriptor,sString) 
   
   ocPDF.PDFEndPage() 
 
   ocPDF.PDFEndDocument(sDocument,1)
    
PRINT
PRINT "Press any key"
SLEEP























