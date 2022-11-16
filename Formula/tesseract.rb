class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/5.2.0.tar.gz"
  sha256 "eba4deb2f92a3f89a6623812074af8c53b772079525b3c263aa70bbf7b748b3c"
  license "Apache-2.0"
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f3b29c4623a28cbacc1a15f62278151adc42cff53a9e864ddb5015f215456481"
    sha256 cellar: :any,                 arm64_monterey: "29070e144239d3c19a40c8a5d1e65da4d299c6f808727c8b488b8e1b41ff19c7"
    sha256 cellar: :any,                 arm64_big_sur:  "132afbe46ecb9a0538dc98500416a1c8e71251a46e323d3901388b2e1c5cbc24"
    sha256 cellar: :any,                 ventura:        "c15d44d1307413f3a40436f1fc89bce2b9e3c0e07412481fc06d7aa012fed868"
    sha256 cellar: :any,                 monterey:       "11139a8136168811d6f940deaadb510178a09fb1349016a1cdee57044423cc4a"
    sha256 cellar: :any,                 big_sur:        "86ea450b30f352141233c9e489d6dbc28b54d845fba3df034d6fa533702f0c1f"
    sha256 cellar: :any,                 catalina:       "eed4277512f94c92f37e9e51ff45be0909ddda2f09ee943fa29567100bda047a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce05d6686c7469864529b371da41b4c384d856c71c1c2adfd6f035a37eba4432"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "leptonica"
  depends_on "libarchive"

  fails_with gcc: "5"

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/eng.traineddata"
    sha256 "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "snum" do
    url "https://github.com/USCDataScience/counterfeit-electronics-tesseract/raw/319a6eeacff181dad5c02f3e7a3aff804eaadeca/Training%20Tesseract/snum.traineddata"
    sha256 "36f772980ff17c66a767f584a0d80bf2302a1afa585c01a226c1863afcea1392"
  end

  resource "test_resource" do
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
    resource("test_resource").stage do
      system bin/"tesseract", "./eurotext.tif", "./output", "-l", "eng"
      assert_match "The (quick) [brown] {fox} jumps!\n", File.read("output.txt")
    end
  end
end
