class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://tesseract-ocr.github.io/"
  url "https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.5.4.tar.gz"
  sha256 "a8dbf8b8c8ee427ff6ad1d99116502feaf59440af1adb893caf60a6576826cf4"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a1043ac1d8f9b6516a229053b2a7a3582262a5e0e8bffcfb0ea6c690bbe9163d"
    sha256 arm64_tahoe:       "776289553b4fa083cc1aff802da6b5e21ce237b3c27ea7f38ab0db69970c8a56"
    sha256 arm64_sequoia:     "162eaadab1881452c05f8241590594f16f8b79276625d3058eb80f24cd6baad4"
    sha256 arm64_linux:       "d2d715da52c8ca14be8ad09f6a5802bc78e7d27a3ecfac9f36b900169b39c0de"
    sha256 x86_64_linux:      "bfd71cb56ca4a37693424184a3162c7e22fdaaad0fe2a05992860f4c27c03a98"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "icu4c@79"
  depends_on "leptonica"
  depends_on "libarchive"
  depends_on "pango"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
  end

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/eng.traineddata"
    sha256 "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "homebrew-test_resource", :test do
    url "https://raw.githubusercontent.com/tesseract-ocr/test/6dd816cdaf3e76153271daf773e562e24c928bf5/testing/eurotext.tif"
    sha256 "7b9bd14aba7d5e30df686fbb6f71782a97f48f81b32dc201a1b75afe6de747d6"
  end

  # Test downloads a sample image to OCR
  allow_network_access! :test

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--datarootdir=#{HOMEBREW_PREFIX}/share",
                          "--disable-silent-rules",
                          *std_configure_args

    system "make", "training"

    # make install in the local share folder to avoid permission errors
    system "make", "install", "training-install", "datarootdir=#{share}"

    resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
    resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
  end

  def caveats
    <<~EOS
      This formula contains only the "eng" and "osd" language data files.
      If you need any other supported languages, run `brew install tesseract-lang`.
    EOS
  end

  test do
    resource("homebrew-test_resource").stage do
      system bin/"tesseract", "./eurotext.tif", "./output", "-l", "eng"
      assert_match "The (quick) [brown] {fox} jumps!\n", File.read("output.txt")
    end
  end
end
