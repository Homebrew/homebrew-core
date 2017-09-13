class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "http://www.xsane.org"
  url "http://www.xsane.org/download/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  revision 2

  bottle do
    sha256 "c1a94d6bdeaf042c47843ec56572e66770de3b20e67ea6dfa7860de3852f9693" => :sierra
    sha256 "e0bc65a90a76de12679aa853be48f2b3b4a5a9ddae3070a8409c84ec093642aa" => :el_capitan
    sha256 "bcd6cdaf240371d79ed0385a41e2e3eaec76616d2086be93fdd3b673c2aa9187" => :yosemite
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
