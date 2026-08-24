class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://tesseract-ocr.github.io/"
  url "https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.5.3.tar.gz"
  sha256 "9218e62793116d42a9f6d14cd9348518b27f382096eea3d0f2d1a24616bb5884"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "03dea8d2bf1d6347451c0e17cfd65d22ff6c044a17454d4c30462fb74f215338"
    sha256               arm64_sequoia: "7d38a25067344a9b7ba957e4f81545773712402b8910dd9f0669187c32d06dd0"
    sha256               arm64_sonoma:  "5a992bfcbb16e0dd15250c490bb0df82545eb9113713b3bfea3ca273a36fe649"
    sha256 cellar: :any, sonoma:        "7812d545b7d2dca8faf68285b50a6194a36a514c2d4ddd481f8cf940a149a4f2"
    sha256               arm64_linux:   "c6dba43df5ca3e27ae7651cea0a6a430e9b5d9b0e45f4546539cc169165a4f8d"
    sha256               x86_64_linux:  "ac74070e7c7664eed6de295a4d461b3e6295c34ada2e5aa1fb75ea08325be5d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
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
