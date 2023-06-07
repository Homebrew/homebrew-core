class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "https://ufraw.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"
  revision 5

  bottle do
    sha256 arm64_ventura:  "e8ebe194de0a2b0abc47fbba2a18729e261294a7128f9124daba92f31ebd56de"
    sha256 arm64_monterey: "b83f6e4a6e1c65437da3f79385b87c4e34282bf116f69860be96866cc1f08652"
    sha256 arm64_big_sur:  "738c930141c10646e2838eae83f5436346cb617aad1272e024cde80b1e288b03"
    sha256 ventura:        "c6aeaadf650b049cecdf42d8e5f3647f440817b382f6d950e71198c0c8f8e7fd"
    sha256 monterey:       "57daa4e9573a66030817ba412cf5989555cf569a6e156e4128598e6eabc2c419"
    sha256 big_sur:        "8daab4a6aff60fba25cb522f217f4aee722b018825506de0b8a3b1127372109c"
    sha256 catalina:       "c908174e4789deed5e024420d7b65dcaf53fd82293d52015a32d10ee1b3a0660"
  end

  deprecate! date: "2022-11-22", because: :unmaintained

  depends_on "pkg-config" => :build
  depends_on "dcraw"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jasper"
  depends_on "jpeg-turbo"
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
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d5bf686c740d9ee0fdf0384ef8dfb293c5483dd2/ufraw/high_sierra.patch"
      sha256 "60c67978cc84b5a118855bcaa552d5c5c3772b407046f1b9db9b74076a938f6e"
    end
  end

  def install
    system "./configure", *std_configure_args,
                          "--without-gtk",
                          "--without-gimp"
    system "make", "install"
    (share/"pixmaps").rmtree
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ufraw-batch --version 2>&1")
  end
end
