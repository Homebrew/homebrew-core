class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "https://gitlab.com/sane-project/frontend/xsane"
  license "GPL-2.0-or-later"
  revision 7

  stable do
    # TODO: Switch to `gtk+3` on next release
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
    mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
    sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"

    depends_on "gtk+"

    # Backport support for libpng 1.5+
    patch do
      url "https://gitlab.com/sane-project/frontend/xsane/-/commit/c2b5b530347af80cb192b30a4bd6039e7714a4fb.diff"
      sha256 "9a94caf7fee69e047eca8d947c4f275473a2fa6d1ee2f0fb116bc2efdd9ea7e8"
    end
  end

  livecheck do
    url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/"
    regex(/href=.*?xsane[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4dca3c238d407fc9c1a7f0f1b7c270f0cffefc2f7955a4af932193b8313e0164"
    sha256 arm64_sequoia:  "e1bc40a49753404b609fce74f94ae755ef6ed1c6ca575703ecd167ff2c26d8b2"
    sha256 arm64_sonoma:   "5532780b9dd6f8768a38d4fa9a845df83367ef96d0514ac41a7f3d337b4a20b5"
    sha256 arm64_ventura:  "937f1a294ababd5e2c7815c599a185b83e67bb07ef6f86da4773bfcfcead1876"
    sha256 arm64_monterey: "c7fc7231fcb5d959fc393a50388e7fa2bd152d6dde8dd0b2cb5530e2b9aa29c0"
    sha256 sonoma:         "13df5fed03ac7d42542000ac00160e78ccb95e79877426719f51c27d38d888e4"
    sha256 ventura:        "7f62506c8cdd4ed11beaaa735d3d9d49b034fd9b22595b58c1437bca0fb44390"
    sha256 monterey:       "be01888247a3d7e510e17a484822c170dd3b7159eb97a73c2dd635a017a199be"
    sha256 arm64_linux:    "7b14c66ec45e121d52e56aa03b84ad17e05537e1b7946f24cd0ea77124b3ef2e"
    sha256 x86_64_linux:   "38f48e2fb08a821089e4419e0b0a6d6994a9e3d1faa009e3319107a4b393af03"
  end

  head do
    url "https://gitlab.com/sane-project/frontend/xsane.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk+3"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sane-backends"

  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    if build.head?
      # Work around https://gitlab.com/sane-project/frontend/xsane/-/issues/74
      inreplace "src/Makefile.am", "$(GIMP_LIBS)", "\\0 $(ZLIB_LIBS)"

      system "autoreconf", "--force", "--install", "--verbose"
    elsif version > "0.999"
      odie "Remove `-Wno-implicit-function-declaration` workaround"
    elsif DevelopmentTools.clang_build_version >= 1200
      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # (xsane:27015): Gtk-WARNING **: 12:58:53.105: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"xsane", "--version"
  end
end
