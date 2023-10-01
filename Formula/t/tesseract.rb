class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/5.3.2.tar.gz"
  sha256 "b99d30fed47360d7168c3e25d194a7416ceb1d9e4b232c7f121cc5f77084d3e7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "15ece02075645126c3c3631fd4d11b535ed5e29f54a29e85d756f414d9d8a040"
    sha256 cellar: :any,                 arm64_ventura:  "d16c37b9e59fbe63d93ab0b3625d106be443d9adc03a0c2bba83460733b1974a"
    sha256 cellar: :any,                 arm64_monterey: "322cf359943d012bcee4b5484f7b95372d8e072bf67698d37ce58ac4d721ffd2"
    sha256 cellar: :any,                 arm64_big_sur:  "86dc7e056a65562b944be9f7efbaf1637a5a0958d0ac279d8bea782a77b602b2"
    sha256 cellar: :any,                 sonoma:         "9326c639d59e7075170096e2ee8051a0db04744d818091a6d6ec8ed99fe62af7"
    sha256 cellar: :any,                 ventura:        "59908aafca08a99af7a3285b1d94a1543c302dda64e09437a5492fbd569c0238"
    sha256 cellar: :any,                 monterey:       "096a0f3e3041b4799fcbe9e1d0d80a50a84f005f89d516bdbb24a1cb7b9f491c"
    sha256 cellar: :any,                 big_sur:        "724f075c0d95517ec3325a82e86abf8ee3a31658f0fc3e44a3eeba4acece04e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "785fb6a9f3a58492bfb1b4e320891bb51507f3ad6beb71fbbe630e3351e6269a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "icu4c"
  depends_on "leptonica"
  depends_on "libarchive"
  depends_on "pango"

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

    system "make", "training"

    # make install in the local share folder to avoid permission errors
    system "make", "install", "training-install", "datarootdir=#{share}"

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
