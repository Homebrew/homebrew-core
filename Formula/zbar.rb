class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.90.tar.bz2"
  sha256 "9152c8fb302b3891e1cb9cc719883d2f4ccd2483e3430783a2cf2d93bd5901ad"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "0148fabe1084ac13f107a34c15e69a68a4e0de8c1212550ea927d5873450843b"
    sha256 arm64_monterey: "e9b2610d5fa22cd12a463ac2701240acc8f6e1c1c190e6fbe1e8f56b12fb695e"
    sha256 arm64_big_sur:  "66d7b6a0b9cc69e2d0786aa626577abc917adba4dd76b79e7bc959afd9eefb7c"
    sha256 ventura:        "e7b877bc80e132b018fe786882ade65d5650ab81ae7e087c81f1a61d278ffb7f"
    sha256 monterey:       "e3f3cd2101683ec1e5d129d9c590f9e61283dd078968231211c994ebd919eeeb"
    sha256 big_sur:        "7a440c19a50c6dd6ebf77b41a254e78fa5ffc641877ae180d131f1cc0d2f4e6b"
    sha256 catalina:       "6524034479ef1b0329914bba94b9a778f07436a4fdcef8d5685df31152a1d990"
    sha256 x86_64_linux:   "b95de47606556882a0e828e77e7230a3e02d49df3fac48d6692f18e33a9e88b6"
  end

  head do
    url "https://github.com/mchehab/zbar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "imagemagick"
  depends_on "jpeg-turbo"

  on_linux do
    depends_on "dbus"
  end

  fails_with gcc: "5" # imagemagick is built with GCC

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-video",
                          "--without-python",
                          "--without-qt",
                          "--without-gtk",
                          "--without-x"
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end
