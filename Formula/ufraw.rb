class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "https://ufraw.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"
  revision 4

  bottle do
    sha256 arm64_monterey: "65712db00e593e27aba98df72a8cf42cfc4e9f2ea1b9735aa53ac6cc8e0be630"
    sha256 arm64_big_sur:  "1292ad07292c989d5bf6a0240064c1c1ad1922777dcf4684bd773c10c49feb04"
    sha256 monterey:       "dc51dbfae0c036a580f29cc553fa311f83628819030d6d7aaf9a440ae947587d"
    sha256 big_sur:        "198e06b232e2eed95af3c242d4845bb5387d8b27eddffe3d6bf812e1a2e94f79"
    sha256 catalina:       "34967822e68cd4d35655c42372d3520a4f3e449ea675026881dc8a5b3f732e55"
    sha256 x86_64_linux:   "f7c413f5a8fbc677842fba4c5c8c87c60bc3fbab4ca7fd36d52b6a8c8e7eb011"
  end

  depends_on "pkg-config" => :build
  depends_on "dcraw"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b8ed064e0d2567a4ced511755ba0a8cc5ecc75f7/ufraw/jpeg9.patch"
    sha256 "45de293a9b132eb675302ba8870f5b6216c51da8247cd096b24a5ab60ffbd7f9"
  end

  # Fix compilation with Xcode 9 and later,
  # see https://sourceforge.net/p/ufraw/bugs/419/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d5bf686c740d9ee0fdf0384ef8dfb293c5483dd2/ufraw/high_sierra.patch"
    sha256 "60c67978cc84b5a118855bcaa552d5c5c3772b407046f1b9db9b74076a938f6e"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make", "install"
    (share/"pixmaps").rmtree
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ufraw-batch --version 2>&1")
  end
end
