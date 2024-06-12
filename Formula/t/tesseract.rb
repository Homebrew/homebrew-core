class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.4.0.tar.gz"
  sha256 "30ceffd9b86780f01cbf4eaf9b7fc59abddfcbaf5bbd52f9a633c6528cb183fd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c18159a800c3db208ca4ac48a41223795d50d96bb338101aebd28b0a14fdfa49"
    sha256 cellar: :any,                 arm64_ventura:  "b0f2f6b3f81031438b184354081828fa329d31abc5e015cd75be77cbf0619115"
    sha256 cellar: :any,                 arm64_monterey: "655fe566eaa87ca167e6a62563ca4148d7a1a2f6a251f21d7bdf2376dbc46c80"
    sha256 cellar: :any,                 sonoma:         "1506318adafb39d45305a775ba5cac53f6462df067d2aa85f863d50606d09489"
    sha256 cellar: :any,                 ventura:        "78beb92bc43cb96bcda3f00d8cca13a8aefcbf39666ed30ca535649135ea0d79"
    sha256 cellar: :any,                 monterey:       "4a1e198c7acc79855888d9c7b350a50d3085a31601d4843f5c766835a7e93457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ec01279baef11b5a1b8df493db3c44c955becce2da34986901d3538f1f3b2a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "icu4c@75"
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
    resource "homebrew-test_resource" do
      url "https://raw.githubusercontent.com/tesseract-ocr/test/6dd816cdaf3e76153271daf773e562e24c928bf5/testing/eurotext.tif"
      sha256 "7b9bd14aba7d5e30df686fbb6f71782a97f48f81b32dc201a1b75afe6de747d6"
    end

    resource("homebrew-test_resource").stage do
      system bin/"tesseract", "./eurotext.tif", "./output", "-l", "eng"
      assert_match "The (quick) [brown] {fox} jumps!\n", File.read("output.txt")
    end
  end
end
