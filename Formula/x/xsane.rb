class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "https://gitlab.com/sane-project/frontend/xsane"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
  mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/"
    regex(/href=.*?xsane[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5532780b9dd6f8768a38d4fa9a845df83367ef96d0514ac41a7f3d337b4a20b5"
    sha256 arm64_ventura:  "937f1a294ababd5e2c7815c599a185b83e67bb07ef6f86da4773bfcfcead1876"
    sha256 arm64_monterey: "c7fc7231fcb5d959fc393a50388e7fa2bd152d6dde8dd0b2cb5530e2b9aa29c0"
    sha256 sonoma:         "13df5fed03ac7d42542000ac00160e78ccb95e79877426719f51c27d38d888e4"
    sha256 ventura:        "7f62506c8cdd4ed11beaaa735d3d9d49b034fd9b22595b58c1437bca0fb44390"
    sha256 monterey:       "be01888247a3d7e510e17a484822c170dd3b7159eb97a73c2dd635a017a199be"
    sha256 x86_64_linux:   "38f48e2fb08a821089e4419e0b0a6d6994a9e3d1faa009e3319107a4b393af03"
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
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # (xsane:27015): Gtk-WARNING **: 12:58:53.105: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"xsane", "--version"
  end
end
