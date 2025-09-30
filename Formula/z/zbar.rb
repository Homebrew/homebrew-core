class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.93.tar.bz2"
  sha256 "83be8f85fc7c288fd91f98d52fc55db7eedbddcf10a83d9221d7034636683fa0"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url "https://linuxtv.org/downloads/zbar/"
    regex(/href=.*?zbar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "cc7a5ed357e5cbfed0707cbaf736d9519473252cffa52dff1a449640be47a9af"
    sha256 arm64_sequoia: "fe42da9d30318b93a75645b76806c1ffe684db56c7f6c0e608c718f9cc7f8f37"
    sha256 arm64_sonoma:  "c6a2988931330f8b9330b259d53096e58b25c9c54a3dc167688774412f885993"
    sha256 arm64_ventura: "22dcfaed8be4e8e396d6e7f6ca5b9dafc04d83e16c78674a665c0742ba9c0c67"
    sha256 sonoma:        "63ecefc21c58f41dcc73346b81fd1defabf3f2db855ec4a18fd0b63ec0cd5326"
    sha256 ventura:       "420f056fecb135dd17684d4f7c62825368e2a0a52df6aabbaaf9823c819d6ba6"
    sha256 arm64_linux:   "53a60318800d01d8d5571cd82ada66c60dc14a7c739c5f4810358dbbbcbcd649"
    sha256 x86_64_linux:  "ecb7269a350f91339a4c6c05d014e27f38311431e54e948fa575aacb2056f03e"
  end

  head do
    url "https://github.com/mchehab/zbar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build

  depends_on "imagemagick"
  depends_on "jpeg-turbo"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "glib"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "dbus"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--disable-video",
                          "--without-python",
                          "--without-qt",
                          "--without-gtk",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end
