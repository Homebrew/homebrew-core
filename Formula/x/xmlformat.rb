class Xmlformat < Formula
  desc "Format XML documents"
  homepage "https://web.archive.org/web/20160929174540/http://www.kitebird.com/software/xmlformat/"
  url "https://web.archive.org/web/20161110001923/http://www.kitebird.com/software/xmlformat/xmlformat-1.04.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/x/xmlformat/xmlformat_1.04.orig.tar.gz"
  sha256 "71a70397e44760d67645007ad85fea99736f4b6f8679067a3b5f010589fd8fef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65b8ac9770d3a9b885318529fd73469a4c341d790174568baba41f0b72c25b7f"
  end

  deprecate! date: "2024-01-10", because: :repo_removed

  def install
    bin.install "xmlformat.pl" => "xmlformat"
  end

  test do
    system "#{bin}/xmlformat", "--version"
  end
end
