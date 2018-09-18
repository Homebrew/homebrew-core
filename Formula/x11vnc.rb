class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "http://www.karlrunge.com/x11vnc/"
  url "https://downloads.sourceforge.net/project/libvncserver/x11vnc/0.9.13/x11vnc-0.9.13.tar.gz"
  sha256 "f6829f2e629667a5284de62b080b13126a0736499fe47cdb447aedb07a59f13b"
  revision 1

  bottle do
    cellar :any
    sha256 "388752257323e1376251e32dea385830afd3a11215b3661dc928111442cb2b5c" => :mojave
    sha256 "3ed573fd3d02c34f407858af3f6e01386d1af2fc9fee16258eea94a4b2c19137" => :high_sierra
    sha256 "3f840749807f57b4248c9ae202a214209c4bf4c4e7386d47da83b424153abe2a" => :sierra
    sha256 "f4a33301592ef159be8f999fce086875bf88afd6ad2b48d6709c2f32d4ab3be1" => :el_capitan
    sha256 "38e07e6c3a26cf1e8d60f1a4e7061da400afb9bb2803f0dd79566c5a3bfd0d22" => :yosemite
  end

  depends_on "jpeg"
  depends_on "openssl"
  depends_on :x11 => :optional

  # Patch solid.c so a non-void function returns a NULL instead of a void.
  # An email has been sent to the maintainers about this issue.
  patch :DATA

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make"
    system "make", "MKDIRPROG=mkdir -p", "install"
  end

  test do
    system bin/"x11vnc", "--version"
  end
end

__END__
diff --git a/x11vnc/solid.c b/x11vnc/solid.c
index d6b0bda..0b2cfa9 100644
--- a/x11vnc/solid.c
+++ b/x11vnc/solid.c
@@ -177,7 +177,7 @@ unsigned long get_pixel(char *color) {
 
 XImage *solid_root(char *color) {
 #if NO_X11
-	RAWFB_RET_VOID
+	RAWFB_RET(NULL)
 	if (!color) {}
 	return NULL;
 #else
