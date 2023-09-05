class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "https://gitlab.com/sane-project/frontend/xsane"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
  mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  license "GPL-2.0-or-later"
  revision 6

  livecheck do
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/"
    regex(/href=.*?xsane[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d2d0507a2156f930eef16374780022edf4e976e7a5bde9c7dcf7ac81a9725dca"
    sha256 arm64_monterey: "0c763e8bdd1f31f25a5cde4f9f723719d6c4f2f7adf8a03148d05d18e690cf1e"
    sha256 arm64_big_sur:  "85b52863f5e9fcbfeaa5802e86087d9a1cfbbd40ca725f8a7abb36c561882c64"
    sha256 ventura:        "08ef991d405a28926b28221dd64263751ca579106b8459e22f721d674d5a0874"
    sha256 monterey:       "c1b28359dc4961aa9f705c3f0336da59ce5e303add9312d075fd1d48f7774b01"
    sha256 big_sur:        "a4ad4d5b415fb56d65d87ec43898a2af0165c267eb709863cca9d8faf7736a70"
    sha256 x86_64_linux:   "321247fec8198f7580ec51d2e237588c837bd1df6683c80eb49e0b36cf5bbef6"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+" # GTK3 issue: https://gitlab.com/sane-project/frontend/xsane/-/issues/34
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sane-backends"

  # Needed to compile against libpng 1.5, Project appears to be dead.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e1a592d/xsane/patch-src__xsane-save.c-libpng15-compat.diff"
    sha256 "404b963b30081bfc64020179be7b1a85668f6f16e608c741369e39114af46e27"
  end

  def install
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if OS.mac?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # (xsane:27015): Gtk-WARNING **: 12:58:53.105: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/xsane", "--version"
  end
end
