class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "http://www.xsane.org"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
  mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  revision 3

  bottle do
    sha256 "028fa4b1496e6e0a0d6f0443bff7157b5bb70e56b1a9fd1e1b83072aa076f6a1" => :mojave
    sha256 "197b36716d2df9e81581650549571ce379ce74290fb45c703e6173c190024dad" => :high_sierra
    sha256 "cb6cd9fabadf727b9414d4a252fa648f579bfe168eb44dd25fb2cb18a84395ed" => :sierra
    sha256 "4346e2b40f260128b2ac562cff15be61c96bcc31b04457f44e41d28aeb7d6be2" => :el_capitan
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
