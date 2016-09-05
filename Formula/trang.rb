class Trang < Formula
  desc "XML schema converter"
  homepage "https://code.google.com/archive/p/jing-trang/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jing-trang/trang-20091111.zip"
  sha256 "d8a3f034f9918ebe5b265aafeadbee6729ddda5732cfc368e2c30b3b8c0ca598"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"trang.jar", "trang"
  end
end
