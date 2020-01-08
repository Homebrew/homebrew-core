class TesseractLang < Formula
  desc "Enables extra languages support for Tesseract"
  homepage "https://github.com/tesseract-ocr/tessdata_fast/"
  url "https://github.com/tesseract-ocr/tessdata_fast/archive/4.0.0.tar.gz"
  sha256 "f1b71e97f27bafffb6a730ee66fd9dc021afc38f318fdc80a464a84a519227fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cfe25847d5eaa4983c7b5ae2b6973bd036ce7363b4332cc66e1ab1b8d41a0d5" => :catalina
    sha256 "631211ef37fcafa9a3fac6a7cd6ca94aaeca83ae28543716a7aaa9cf1072d414" => :mojave
    sha256 "631211ef37fcafa9a3fac6a7cd6ca94aaeca83ae28543716a7aaa9cf1072d414" => :high_sierra
    sha256 "4c69eedd24721f0e47a645ae20a08bf8c8083f805615c7b46a73406a9f593cb1" => :sierra
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
