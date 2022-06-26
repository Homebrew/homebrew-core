class Xmlformat < Formula
  desc "Format XML documents"
  homepage "http://www.kitebird.com/software/xmlformat/"
  url "http://www.kitebird.com/software/xmlformat/xmlformat-1.04.tar.gz"
  sha256 "71a70397e44760d67645007ad85fea99736f4b6f8679067a3b5f010589fd8fef"

  livecheck do
    url :homepage
    regex(/href=.*?xmlformat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65b8ac9770d3a9b885318529fd73469a4c341d790174568baba41f0b72c25b7f"
  end

  def install
    bin.install "xmlformat.pl" => "xmlformat"
  end

  test do
    system "#{bin}/xmlformat", "--version"
  end
end
