class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/5.3.0.tar.gz"
  sha256 "7e70870f8341e5ea228af2836ce79a36eefa11b01b56177b4a8997f330c014b8"
  license "Apache-2.0"
  revision 2
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "543e244a690efd83103ff04fc546ec1f4f3bef2653f79fbcfad98d13b0b91dc2"
    sha256 cellar: :any,                 arm64_monterey: "372389eded0fc4ca1f5d0f68e84c2cffcc218793c59e853c28f433dddf8d195c"
    sha256 cellar: :any,                 arm64_big_sur:  "c889f9d20cca008850c6aeb6691b6c7280febf92d26ef89af09747d64122c374"
    sha256 cellar: :any,                 ventura:        "99e8abb0e573f47ca5084ef7627b0a459daf8683a00241dac0d9b05074d0bafe"
    sha256 cellar: :any,                 monterey:       "d397ffe212b5b9ab02b66e4eec1a4ee2ac09253fd340c7c55c4d54b8b1ffa640"
    sha256 cellar: :any,                 big_sur:        "acfe1e1827f912feedceb1bb9a772c7f2e3ec016440ff8ac31ab8f81791d190c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a744887b6b911905dc48af372ef9923870e789d502cd2dd2d6b99787f0f110a"
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
