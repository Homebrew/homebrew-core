class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/5.3.1.tar.gz"
  sha256 "3761768c02b99358e5118bfabfecc979fa84a399da5fa54c49dd477d926fef43"
  license "Apache-2.0"
  revision 1
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "920e633ece7cfe00a7df90f9dfce8fc8349e6de6494c87a9e814865c221cefe3"
    sha256 cellar: :any,                 arm64_monterey: "060c5e81b7731d5180e094c7d7173c27959c6b59bbf4c4df9318b213f4602913"
    sha256 cellar: :any,                 arm64_big_sur:  "92c508f2c9c5591d30cdeeae7463d5b6054add597fb50dfa7301ccd0eb6287b9"
    sha256 cellar: :any,                 ventura:        "4259cd9df9589653a012c67c051a296ed1899014d218a020f204d5336a2da152"
    sha256 cellar: :any,                 monterey:       "46ac62910f0f1bf32c82f632916c2c57b354b7b911cfd1e980359ae1027304b6"
    sha256 cellar: :any,                 big_sur:        "6613c2ef5de2a1a17233f5eead08bc9f2428b2b17995e9649868e47bc95f54b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea6c8d18031330394dae1377c76b8e006e38d7ff5f898735febb6421360adfe2"
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
