class Xmbdfed < Formula
  desc "Bitmap Font Editor (Motif edition) for BDF fonts, and a few other formats"
  homepage "https://web.archive.org/web/20040603074556/http://crl.nmsu.edu/~mleisher/download.html"
  url "https://web.archive.org/web/20040603074556/http://crl.nmsu.edu/~mleisher/xmbdfed-4.7.tar.bz2"
  sha256 "d1807ae89238261738d6bf69e900eabdfe1f54cf110329ebde4b6a26cc134e65"
  license "MIT"

  deprecate! date: "2026-08-04", because: "upstream has abandoned xmbdfed and homebrew uses web.archive.org"

  depends_on "freetype"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  # Patch XmBDFEditor 4.7 Patch 1 from author
  # https://web.archive.org/web/20040603074556/http://crl.nmsu.edu/~mleisher/xmbdfed-4.7-patch1
  patch <<~EOP
Index: FGrid.c
===================================================================
RCS file: /home/sml/cvsrep/misc/xmbdfed/FGrid.c,v
retrieving revision 1.28
diff -u -r1.28 FGrid.c
--- FGrid.c	8 Feb 2004 23:58:59 -0000	1.28
+++ FGrid.c	2 Mar 2004 17:59:28 -0000
@@ -4267,7 +4267,7 @@
     pi->sel_start = pi->sel_end = cb.start;
     Select(pi->sel_start, pi->selmap);
 
-    _XmuttFGridDrawCells(fw, pi->sel_start, pi->sel_end, True, True);
+    _XmuttFGridDrawCells(fw, cb.start, cb.end, True, True);
 
     /*
      * Call the modified callback.
  EOP

  # For security, use a literal string for the fprintf() format.
  patch <<~EOP
    diff --git a/bdf.c b/bdf.c
    index 38c6e9f..44c5fc3 100644
    --- a/bdf.c
    +++ b/bdf.c
    @@ -3058,14 +3058,14 @@ void *data;
             bpr = ((c->bbx.width * font->bpp) + 7) >> 3;
             for (j = 0; bpr != 0 && j < c->bytes; j++) {
                 if (j && j % bpr == 0)
    -              fprintf(out, eol);
    +              fprintf(out, "%s", eol);
                 fprintf(out, "%02X", c->bitmap[j]);
             }
             /*
              * Handle empty bitmaps like this.
              */
             if (c->bbx.height > 0)
    -          fprintf(out, eol);
    +          fprintf(out, "%s", eol);
             fprintf(out, "ENDCHAR%s", eol);
    #{" "}
             /*
    @@ -3130,14 +3130,14 @@ void *data;
             bpr = ((c->bbx.width * font->bpp) + 7) >> 3;
             for (j = 0; bpr != 0 && j < c->bytes; j++) {
                 if (j && j % bpr == 0)
    -              fprintf(out, eol);
    +              fprintf(out, "%s", eol);
                 fprintf(out, "%02X", c->bitmap[j]);
             }
             /*
              * Handle empty bitmaps like this.
              */
             if (c->bbx.height > 0)
    -          fprintf(out, eol);
    +          fprintf(out, "%s", eol);
             fprintf(out, "ENDCHAR%s", eol);
    #{" "}
             /*
  EOP

  # Patch help text and man page for typos
  patch <<~'EOP'
    diff --git a/htext.h b/htext.h
    index 892fbfa..f643dd3 100644
    --- a/htext.h
    +++ b/htext.h
    @@ -1230,7 +1230,7 @@ the configuration file:\n\
     static char *otf_text = "\
     If this program was compiled with the FreeType\n\
     library to support importing OpenType fonts\n\
    -(.otf extension), TrueType fonts (.ttfextension), and\n\
    +(.otf extension), TrueType fonts (.ttf extension), and\n\
     TrueType collections (.ttc extension),\n\
     when importing a font or collection, a dialog\n\
     will be presented to allow you to choose a single font,\n\
    diff --git a/xmbdfed.man b/xmbdfed.man
    index dc8c1d7..5d302d3 100644
    --- a/xmbdfed.man
    +++ b/xmbdfed.man
    @@ -21,7 +21,7 @@ console fonts (PSF, CP, and EGA/VGA) fonts, Sun VF fonts, TrueType (TTF)
     fonts, or grab a font from the X server.
     .I xmbdfed
     can export PSF2 Linux console fonts and HEX fonts (see online help).
    -The editor support two and four bits per pixel gray scale fonts.
    +The editor supports two and four bits per pixel gray scale fonts.

     .I xmbdfed
     works on X Window System Version 11 (X11), Release 5 or Release
    @@ -86,8 +86,8 @@ set default vertical resolution.
     .I -res n
     set both default resolutions (if unspecified,
     .I xmbdfed
    -sets both horizontal and vertical resolution to that of display,
    -(e.g. 90x90 dpi for Sun workstations).
    +sets both horizontal and vertical resolution to that of display;
    +for example 90x90 dpi for Sun workstations).
     .PP
     .TP 8
     .I -sp s
    @@ -102,13 +102,12 @@ set the default bits per pixel for new fonts (1, 2, or 4).
     .I -eol e
     set the default end-of-line type ("u" for Unix LF, "d" for DOS/Windows CRLF,
     or "m" for Macintosh CR).
    -CR)
     .PP
     .TP 8
     .I -g glyph-code
     specify the initial glyph code at startup.  The glyph code can be specified in
    -decimal, octal, or hex.  Octal numbers must be prefixed with the digit 0, and
    -hex numbers must be prefixed with one of: \fI0x, 0X, U+, U-, \\u\fP.
    +decimal, octal, or hexadecimal.  Octal numbers must be prefixed with the digit 0, and
    +hexadecimal numbers must be prefixed with one of: \fI0x, 0X, U+, U-, \\u\fP.
     .PP
     .TP 8
     .I -pb
    @@ -298,7 +297,7 @@ Font Grid clipboard.
     .PP
     .TP 4
     .I Overlay <Ctrl+Shift+V> or Ctrl<Button2Down>
    -This merges the Font Grid cliboard with the glyphs starting at the currently
    +This merges the Font Grid clipboard with the glyphs starting at the currently
     selected position.  The names of the modified glyphs are not changed.
     .PP
     .TP 4
    @@ -440,7 +439,7 @@ The option of rotating the selected glyphs or all of the glyphs is provided.
     .PP
     .TP 4
     .I Shear <Ctrl+J>
    -This will bring up the dialog for entering theangle of the shear.  The shear
    +This will bring up the dialog for entering the angle of the shear.  The shear
     is limited to plus or minus 45 degrees.
     .sp
     The option of rotating the selected glyphs or all of the glyphs is provided.
  EOP

  # Patch Makefile for homebrew paths and libraries
  # and fix the C for various age-related problems.
  # Patch input is in data segment at end, see https://docs.brew.sh/Formula-Cookbook#patches
  patch :DATA

  def install
    system "make"
    mkdir bin.to_s
    bin.install "xmbdfed"
    man1.mkpath
    man1.install "xmbdfed.man"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test xmbdfed`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # xmbdfed will not run without an X server; not even to display its usage
    # or report a version. So the test is very weak: Check file exists
    system "test", "-x", bin/"xmbdfed"
  end
end
__END__
diff --git a/Makefile b/Makefile
index d869411..f97430f 100644
--- a/Makefile
+++ b/Makefile
@@ -46,9 +46,9 @@ OBJS = FGrid.o GEdit.o GEditTB.o GTest.o ProgBar.o bdf.o bdfcons.o bdffnt.o \
 # Uncomment these if you have the FreeType library and want to use it to
 # import OpenType fonts.
 #
-#FTYPE_INCS = -I/usr/local/include
-#FTYPE_LIBS = -L/usr/local/lib -lfreetype
-#FTYPE_DEFS = -DHAVE_FREETYPE
+FTYPE_INCS = -I/opt/homebrew/include/freetype2
+FTYPE_LIBS = -lfreetype
+FTYPE_DEFS = -DHAVE_FREETYPE
 
 #
 # Uncomment these if you have the hbf.h and hbf.c files in the current
@@ -92,6 +92,10 @@ LIBS = -R/usr/openwin/lib -R/usr/dt/lib -L/usr/dt/lib -lXm \
 #INCS = -I/usr/X11/include $(FTYPE_INCS)
 #LIBS = -L/usr/X11/lib -lXm -lXpm -lXmu -lXt -lXext -lX11 -lSM -lICE $(FTYPE_LIBS)
 
+# homebrew
+INCS = -I/opt/homebrew/include $(FTYPE_INCS)
+LIBS = -L/opt/homebrew/lib -lXm -lXpm -lXmu -lXt -lXext -lX11 -lSM -lICE $(FTYPE_LIBS)
+
 #
 # Uncomment these for HPUX.
 #
diff --git a/bdfgname.c b/bdfgname.c
index 80e99ee..e83ed31 100644
--- a/bdfgname.c
+++ b/bdfgname.c
@@ -47,9 +47,9 @@ static unsigned long adobe_names_used;
 
 static int
 #ifdef __STDC__
-getline(FILE *in, char *buf, int limit)
+_bdf_getline(FILE *in, char *buf, int limit)
 #else
-getline(in, buf, limit)
+_bdf_getline(in, buf, limit)
 FILE *in;
 char *buf;
 int limit;
@@ -99,11 +99,11 @@ FILE *in;
 
     while (!feof(in)) {
         pos = ftell(in);
-        (void) getline(in, buf, 256);
+        (void) _bdf_getline(in, buf, 256);
         while (!feof(in) && (buf[0] == 0 || buf[0] == '#')) {
             buf[0] = 0;
             pos = ftell(in);
-            (void) getline(in, buf, 256);
+            (void) _bdf_getline(in, buf, 256);
         }
 
         if (buf[0] == 0)
@@ -170,11 +170,11 @@ FILE *in;
 
     while (!feof(in)) {
         pos = ftell(in);
-        (void) getline(in, buf, 256);
+        (void) _bdf_getline(in, buf, 256);
         while (!feof(in) && (buf[0] == 0 || buf[0] == '#')) {
             buf[0] = 0;
             pos = ftell(in);
-            (void) getline(in, buf, 256);
+            (void) _bdf_getline(in, buf, 256);
         }
 
         c = _bdf_atol(buf, 0, 16);
diff --git a/bdfgrab.c b/bdfgrab.c
index 62825d7..86c9a0d 100644
--- a/bdfgrab.c
+++ b/bdfgrab.c
@@ -276,7 +276,7 @@ void *data;
     XCharStruct *cp;
     bdf_property_t *pp, prop;
     bdf_callback_struct_t cb;
-    int (*old_error_handler)();
+    int (*old_error_handler)(Display *d, XErrorEvent *event);
 
     if (f == 0)
       return 0;
diff --git a/setup.c b/setup.c
index a417549..4dd94eb 100644
--- a/setup.c
+++ b/setup.c
@@ -92,7 +92,6 @@ typedef struct {
     Boolean saved;
 } MXFEditorSetup;
 
-static unsigned long active_editor;
 static MXFEditorSetup setup;
 static MXFEditorOtherOptions other;
 
