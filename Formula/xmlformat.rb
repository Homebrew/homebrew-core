class Xmlformat < Formula
  desc "Format XML documents"
  homepage "https://web.archive.org/web/20180624200351/www.kitebird.com/software/xmlformat/"
  url "https://web.archive.org/web/20180624200351/www.kitebird.com/software/xmlformat/xmlformat-1.04.tar.gz"
  sha256 "71a70397e44760d67645007ad85fea99736f4b6f8679067a3b5f010589fd8fef"

  bottle :unneeded

  def install
    bin.install "xmlformat.pl" => "xmlformat"
  end

  test do
    system "#{bin}/xmlformat", "--version"
  end
end
