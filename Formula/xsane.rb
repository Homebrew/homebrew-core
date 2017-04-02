class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "http://www.xsane.org"
  url "http://www.xsane.org/download/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  revision 1

  bottle do
    sha256 "d8986e38bfaee594922515ca9406213ddabb52c39d8567b997fe3008acc504e6" => :sierra
    sha256 "7608ab59dd7e21a4c6bff5ccb29e682fd9dbcff9be876516e85fcacff10719f6" => :el_capitan
    sha256 "df7b1492a1b526a7883fc810cffc2a974e297f0f287be44047f6795a7ae5e8f0" => :yosemite
    sha256 "64b437736bc0f0c16d0c5bec06facb010939709c4a6923835337e4a5ee63b096" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "sane-backends"

  # Needed to compile against libpng 1.5, Project appears to be dead.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e1a592d/xsane/patch-src__xsane-save.c-libpng15-compat.diff"
    sha256 "404b963b30081bfc64020179be7b1a85668f6f16e608c741369e39114af46e27"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xsane", "--version"
  end
end
