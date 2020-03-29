class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/4.1.1.tar.gz"
  sha256 "2a66ff0d8595bff8f04032165e6c936389b1e5727c3ce5a27b3e059d218db1cb"
  head "https://github.com/tesseract-ocr/tesseract.git"

  bottle do
    cellar :any
    sha256 "81ff467946d9c85151c86819034cd183a983b4a3fa10374c7f039a5ec3ef0d82" => :catalina
    sha256 "34eee505fccec07eaab30f14c46f9688db9f3aa578306d47bbcd31801b0b849d" => :mojave
    sha256 "6b64585454bcca9b62945b284000723d76afad15b5e80109ca6cdc699ae50e25" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "leptonica"
  depends_on "libtiff"

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.0.0/eng.traineddata"
    sha256 "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.0.0/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "snum" do
    url "https://github.com/USCDataScience/counterfeit-electronics-tesseract/raw/319a6eeacff181dad5c02f3e7a3aff804eaadeca/Training%20Tesseract/snum.traineddata"
    sha256 "36f772980ff17c66a767f584a0d80bf2302a1afa585c01a226c1863afcea1392"
  end

  resource "testfile" do
    url "https://raw.githubusercontent.com/tesseract-ocr/test/6dd816cdaf3e76153271daf773e562e24c928bf5/testing/eurotext.tif"
    sha256 "7b9bd14aba7d5e30df686fbb6f71782a97f48f81b32dc201a1b75afe6de747d6"
  end

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--datarootdir=#{HOMEBREW_PREFIX}/share"

    system "make"

    # make install in the local share folder to avoid permission errors
    system "make", "install", "datarootdir=#{share}"

    resource("snum").stage { mv "snum.traineddata", share/"tessdata" }
    resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
    resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
  end

  def caveats
    <<~EOS
      This formula contains only the "eng", "osd", and "snum" language data files.
      If you need any other supported languages, run `brew install tesseract-lang`.
    EOS
  end

  test do
    resource("testfile").stage do
      system bin/"tesseract", "./eurotext.tif", "./output", "-l", "eng"
      assert_match "The (quick) [brown] {fox} jumps!\n", File.read("output.txt")
    end
  end
end
