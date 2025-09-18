class Xmlformat < Formula
  desc "Format XML documents"
  homepage "https://web.archive.org/web/20160929174540/http://www.kitebird.com/software/xmlformat/"
  url "https://web.archive.org/web/20161110001923/http://www.kitebird.com/software/xmlformat/xmlformat-1.04.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/x/xmlformat/xmlformat_1.04.orig.tar.gz"
  sha256 "71a70397e44760d67645007ad85fea99736f4b6f8679067a3b5f010589fd8fef"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cd9bb59ed3d0a6d32cbf62cf15a6fde64801d7ef21fd5d73070b1f3991dbef50"
  end

  disable! date: "2025-01-10", because: :repo_removed

  def install
    bin.install "xmlformat.pl" => "xmlformat"
  end

  test do
    system bin/"xmlformat", "--version"
  end
end
