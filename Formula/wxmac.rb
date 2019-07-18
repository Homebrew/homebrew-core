class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.4/wxWidgets-3.0.4.tar.bz2"
  sha256 "96157f988d261b7368e5340afa1a0cad943768f35929c22841f62c25b17bf7f0"
  revision 2
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    sha256 "d5dec67eb11005f6eea84a94a9caea3dc20ed23e3295950b4dc3b137c6eccdd3" => :mojave
    sha256 "ed69e867fa97042726a9434488da30381fb3b4f68f4dc7e4499e7bf0edf6eaaa" => :high_sierra
    sha256 "691e2e49b33f78d1189386cf969bfe1f292d3644dbfdf67b92a795656e50870a" => :sierra
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # Adjust assertion which fails for wxGLCanvas due to changes in macOS 10.14.
  # Patch taken from upstream WX_3_0_BRANCH:
  # https://github.com/wxWidgets/wxWidgets/commit/531fdbcb64b265e6f24f1f0cc7469f308b9fb697
  patch :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
    ]

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end

__END__
--- a/src/osx/carbon/dcclient.cpp
+++ b/src/osx/carbon/dcclient.cpp
@@ -189,10 +189,20 @@ wxPaintDCImpl::wxPaintDCImpl( wxDC *owner )
 {
 }

+#if wxDEBUG_LEVEL
+static bool IsGLCanvas( wxWindow * window )
+{
+    // If the wx gl library isn't loaded then ciGLCanvas will be NULL.
+    static const wxClassInfo* const ciGLCanvas = wxClassInfo::FindClass("wxGLCanvas");
+    return ciGLCanvas && window->IsKindOf(ciGLCanvas);
+}
+#endif
+
 wxPaintDCImpl::wxPaintDCImpl( wxDC *owner, wxWindow *window ) :
     wxWindowDCImpl( owner, window )
 {
-    wxASSERT_MSG( window->MacGetCGContextRef() != NULL, wxT("using wxPaintDC without being in a native paint event") );
+    // With macOS 10.14, wxGLCanvas windows have a NULL CGContextRef.
+    wxASSERT_MSG( window->MacGetCGContextRef() != NULL || IsGLCanvas(window), wxT("using wxPaintDC without being in a native paint event") );
     wxPoint origin = window->GetClientAreaOrigin() ;
     m_window->GetClientSize( &m_width , &m_height);
     SetDeviceOrigin( origin.x, origin.y );
