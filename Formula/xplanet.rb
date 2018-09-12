class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"
  revision 2

  bottle do
    sha256 "08b96065da38ab4b0783d6b49cdba670276690a1024557ec3d1aff2de475c3b0" => :mojave
    sha256 "bd4d0b8ed3bf33f6c6da0b43574fb08d054603d0b36b228a87d1ae070274ac7c" => :high_sierra
    sha256 "eedbdc803d69fa1635e763eafa90ffd071b537e994a5fbdbe9eb84e69c0fc645" => :sierra
    sha256 "6d37f0965bc1b1f1aa438fec8ea9e57a096681336dba25dc880f25cb752f3910" => :el_capitan
    sha256 "4c0e0c1b025079129f808e85d3d5e76280799929fa6e9d119000e94283769a8d" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # patches bug in 1.3.1 with flag -num_times=2 (1.3.2 will contain fix, when released)
  # https://sourceforge.net/p/xplanet/code/208/tree/trunk/src/libdisplay/DisplayOutput.cpp?diff=5056482efd48f8457fc7910a:207
  patch :p2 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f952f1d/xplanet/xplanet-1.3.1-ntimes.patch"
    sha256 "3f95ba8d5886703afffdd61ac2a0cd147f8d659650e291979f26130d81b18433"
  end

  # Fix compilation with giflib 5
  # https://xplanet.sourceforge.io/FUDforum2/index.php?t=msg&th=592
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xplanet/xplanet-1.3.1-giflib5.patch"
    sha256 "0a88a9c984462659da37db58d003da18a4c21c0f4cd8c5c52f5da2b118576d6e"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-aqua",
                          "--without-cspice",
                          "--without-cygwin",
                          "--without-gif",
                          "--without-jpeg",
                          "--without-libpng",
                          "--without-libtiff",
                          "--without-pango",
                          "--without-pnm",
                          "--without-x",
                          "--without-xscreensaver"

    system "make", "install"
  end

  test do
    system "#{bin}/xplanet", "-geometry", "4096x2160", "-projection", "mercator", "-gmtlabel", "-num_times", "1", "-output", "#{testpath}/xp-test.png"
  end
end
