class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"
  license "GPL-2.0-or-later"
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "7496e485b462de4b286f4128d145dfc58aaba93237aafc36ec1c0138a740be46"
    sha256                               arm64_sequoia:  "1c5fb1f5235c56e1aa7f84415b49428ed1c92532b47697800982f01dcfb4d842"
    sha256                               arm64_sonoma:   "1092db3b7841f3a9e16d41baa7b4370ab212ec0523275e2b96cad8f2235873e7"
    sha256                               arm64_ventura:  "aa69c74fc48645353401ccfeb35f7bf0527b696f34523754e2c81077459bbc64"
    sha256                               arm64_monterey: "07924721350d8ca211611b26b4e78729062cb040cb1031f88d9fb621106cbf60"
    sha256                               arm64_big_sur:  "a1c93cfbcb085731799a2e3d94c0f4f14b5ef962dbf3f001660c17790faa5a29"
    sha256                               sonoma:         "3a688306c871799a9ec418677bcd9b38bf3ed7eefa80b0433f681cb59c5fadc4"
    sha256                               ventura:        "e567fd98fcd6d0f8903ee632f21b6658756eaff80d46de2730a91d0e600289dc"
    sha256                               monterey:       "0d4fd995ed8518e11c0e7072dba0364b8d9db777625a114aab6696ab927fadf7"
    sha256                               big_sur:        "227cbd44a9be2502a24f459725881e7705263af1a00ae53e38a8cc9b111b87b0"
    sha256                               arm64_linux:    "e4c5d2d7f3a186e8094fe3b0e8ab2502b48c7d6811cca6c024ac4ac771d49b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1ddc436b45234444d121e117b299ec702da829391200dfae26547114834d02"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  # Added automake as a build dependency to update config files for ARM support.
  # Please remove in the future if there is a patch upstream which recognises aarch64 macOS.
  on_arm do
    depends_on "automake" => :build
  end

  # patches bug in 1.3.1 with flag -num_times=2 (1.3.2 will contain fix, when released)
  # https://sourceforge.net/p/xplanet/code/208/tree/trunk/src/libdisplay/DisplayOutput.cpp?diff=5056482efd48f8457fc7910a:207
  patch :p2 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/xplanet/xplanet-1.3.1-ntimes.patch"
    sha256 "3f95ba8d5886703afffdd61ac2a0cd147f8d659650e291979f26130d81b18433"
  end

  # Fix compilation with giflib 5
  # https://xplanet.sourceforge.net/FUDforum2/index.php?t=msg&th=592
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/xplanet/xplanet-1.3.1-giflib5.patch"
    sha256 "0a88a9c984462659da37db58d003da18a4c21c0f4cd8c5c52f5da2b118576d6e"
  end

  # Fix build with C++11 using Arch Linux patch. Remove in the next release.
  # There is an upstream commit but SourceForge doesn't provide a way to get raw patch.
  # Commit ref: https://sourceforge.net/p/xplanet/code/207/
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-community/040965e32860345ca2d744239b6e257da33460a2/trunk/xplanet-c%2B%2B11.patch"
    sha256 "e651c7081c43ea48090186580b5a2a5d5039ab3ffbf34f7dd970037a16081454"
  end

  # Backport https://sourceforge.net/p/xplanet/code/222/
  patch :p0, :DATA

  def install
    # Workaround for ancient config files not recognizing aarch64 macos.
    if Hardware::CPU.arm?
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end

    args = %w[
      --without-cspice
      --without-cygwin
      --with-gif
      --with-jpeg
      --with-libtiff
      --without-pango
      --without-pnm
      --without-x
      --without-xscreensaver
    ]
    args << "--with-aqua" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  # Test all the supported image formats, jpg, png, gif and tiff, as well as the -num_times 2 patch
  test do
    system bin/"xplanet", "-target", "earth", "-output", "#{testpath}/test.jpg",
                          "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
    system bin/"xplanet", "-target", "earth", "--transpng", "#{testpath}/test.png",
                          "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
    system bin/"xplanet", "-target", "earth", "--output", "#{testpath}/test.gif",
                          "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
    system bin/"xplanet", "-target", "earth", "--output", "#{testpath}/test.tiff",
                          "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
  end
end

__END__
--- src/readConfig.cpp	(revision 221)
+++ src/readConfig.cpp	(revision 222)
@@ -46,10 +46,10 @@
         {
         case ARC_COLOR:
         {
-            int r, g, b;
-            if (sscanf(returnString, "%d,%d,%d", &r, &g, &b) == 3)
+            unsigned char r, g, b;
+            if (sscanf(returnString, "%hhu,%hhu,%hhu", &r, &g, &b) == 3)
             {
-                unsigned char color[3] = { r & 0xff, g & 0xff, b & 0xff };
+                unsigned char color[3] = { r, g, b };
                 currentProperties->ArcColor(color);
             }
             else
@@ -176,10 +176,10 @@
         break;
         case COLOR:
         {
-            int r, g, b;
-            if (sscanf(returnString, "%d,%d,%d", &r, &g, &b) == 3)
+            unsigned char r, g, b;
+            if (sscanf(returnString, "%hhu,%hhu,%hhu", &r, &g, &b) == 3)
             {
-                unsigned char color[3] = { r & 0xff, g & 0xff, b & 0xff };
+                unsigned char color[3] = { r, g, b };
                 currentProperties->Color(color);
             }
             else
@@ -241,10 +241,10 @@
         break;
         case GRID_COLOR:
         {
-            int r, g, b;
-            if (sscanf(returnString, "%d,%d,%d", &r, &g, &b) == 3)
+            unsigned char r, g, b;
+            if (sscanf(returnString, "%hhu,%hhu,%hhu", &r, &g, &b) == 3)
             {
-                unsigned char color[3] = { r & 0xff, g & 0xff, b & 0xff };
+                unsigned char color[3] = { r, g, b };
                 currentProperties->GridColor(color);
             }
             else
@@ -293,10 +293,10 @@
         break;
         case MARKER_COLOR:
         {
-            int r, g, b;
-            if (sscanf(returnString, "%d,%d,%d", &r, &g, &b) == 3)
+            unsigned char r, g, b;
+            if (sscanf(returnString, "%hhu,%hhu,%hhu", &r, &g, &b) == 3)
             {
-                unsigned char color[3] = { r & 0xff, g & 0xff, b & 0xff };
+                unsigned char color[3] = { r, g, b };
                 currentProperties->MarkerColor(color);
             }
             else
@@ -400,10 +400,10 @@
         break;
         case ORBIT_COLOR:
         {
-            int r, g, b;
-            if (sscanf(returnString, "%d,%d,%d", &r, &g, &b) == 3)
+            unsigned char r, g, b;
+            if (sscanf(returnString, "%hhu,%hhu,%hhu", &r, &g, &b) == 3)
             {
-                unsigned char color[3] = { r & 0xff, g & 0xff, b & 0xff };
+                unsigned char color[3] = { r, g, b };
                 currentProperties->OrbitColor(color);
             }
             else
@@ -470,10 +470,10 @@
             break;
         case TEXT_COLOR:
         {
-            int r, g, b;
-            if (sscanf(returnString, "%d,%d,%d", &r, &g, &b) == 3)
+            unsigned char r, g, b;
+            if (sscanf(returnString, "%hhu,%hhu,%hhu", &r, &g, &b) == 3)
             {
-                unsigned char color[3] = { r & 0xff, g & 0xff, b & 0xff };
+                unsigned char color[3] = { r, g, b };
                 currentProperties->TextColor(color);
             }
             else
