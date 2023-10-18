class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/5.3.3.tar.gz"
  sha256 "dc4329f85f41191b2d813b71b528ba6047745813474e583ccce8795ff2ff5681"
  license "Apache-2.0"
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50a8324b4de3d633069242bd82d16a6fd0571cd492987392a46ed31109e881a9"
    sha256 cellar: :any,                 arm64_ventura:  "34f7e7048e6285aa45b88c97e86a3def62d8fa56c48765a02fd524461666ef7c"
    sha256 cellar: :any,                 arm64_monterey: "156eae31ede968cd89b3a630c5b73d9e73605b178b1532d6b69a276878f396af"
    sha256 cellar: :any,                 sonoma:         "1de8251f7c22f7809530d20ce2b06c2ff10b6dc538ae2630127d1043c62d4bf9"
    sha256 cellar: :any,                 ventura:        "c4411530f313a35041e5aeb25fed4184c57088269bf8004a89cda45e0e855e7b"
    sha256 cellar: :any,                 monterey:       "f43f7b843699c46b347ef6cebbe639566b24ffab8a03cc7e5281238d7917c887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99419c149e3150ac52ac63a8264f6030d55e1b8ac5eea02a80ba0f8839e099e0"
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
