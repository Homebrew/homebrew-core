class TesseractLang < Formula
  desc "Enables extra languages support for Tesseract"
  homepage "https://github.com/tesseract-ocr/tessdata_fast/"
  url "https://github.com/tesseract-ocr/tessdata_fast/archive/4.0.0.tar.gz"
  sha256 "f1b71e97f27bafffb6a730ee66fd9dc021afc38f318fdc80a464a84a519227fe"

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
      assert_match "über den faulen Hund. Le renard brun\n", shell_output("cat ./output.txt")
    end
  end
end
