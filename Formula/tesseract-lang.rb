class TesseractLang < Formula
  desc "Enables extra languages support for Tesseract"
  homepage "https://github.com/tesseract-ocr/tessdata_fast/"
  url "https://github.com/tesseract-ocr/tessdata_fast/archive/4.1.0.tar.gz"
  sha256 "d0e3bb6f3b4e75748680524a1d116f2bfb145618f8ceed55b279d15098a530f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ce8f09d799cc3483cfba6c3a238b10271507c9e309828521b1f86325a2f79b0"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a4a2646cf813ffa6778f4b110d98666144d2b44dde177f66a663de313f781bb"
    sha256 cellar: :any_skip_relocation, catalina:      "93f7d390e6f209f2f452a181a832d0d88e21b7afc171515cf9eeb3a9ba500ffd"
    sha256 cellar: :any_skip_relocation, mojave:        "28d91c5d2a8efc9f33d5ccc4d8eb76bf0c6649f604d1f9a52e06c3b8e3a2daef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "589b4e7851f76924cf8bd77155f53ffda95bb92cbb19327aed1766000a203760"
    sha256 cellar: :any_skip_relocation, all:           "589b4e7851f76924cf8bd77155f53ffda95bb92cbb19327aed1766000a203760"
  end

  depends_on "tesseract"

  resource "testfile" do
    url "https://raw.githubusercontent.com/tesseract-ocr/test/6dd816cdaf3e76153271daf773e562e24c928bf5/testing/eurotext.tif"
    sha256 "7b9bd14aba7d5e30df686fbb6f71782a97f48f81b32dc201a1b75afe6de747d6"
  end

  def install
    rm "eng.traineddata"
    rm "osd.traineddata"
    (share/"tessdata").install Dir["*"]
  end

  test do
    resource("testfile").stage do
      system "#{Formula["tesseract"].bin}/tesseract", "./eurotext.tif", "./output", "-l", "eng+deu"
      assert_match "über den faulen Hund. Le renard brun\n", File.read("output.txt")
    end
  end
end
