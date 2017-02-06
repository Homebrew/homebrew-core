class Ski < Formula
  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "http://www.catb.org/~esr/ski/ski-6.12.tar.gz"
  sha256 "2f34f64868deb0cc773528c68d9829119fac359c44a704695214d87773df5a33"

  bottle do
    cellar :any_skip_relocation
    sha256 "67711654d0b4888ee6bd623ff75f9311d41c1e0be3a52382ff55b62dd6605f60" => :sierra
    sha256 "67711654d0b4888ee6bd623ff75f9311d41c1e0be3a52382ff55b62dd6605f60" => :el_capitan
    sha256 "67711654d0b4888ee6bd623ff75f9311d41c1e0be3a52382ff55b62dd6605f60" => :yosemite
  end

  head do
    url "git://thyrsus.com/repositories/ski.git"
    depends_on "xmlto" => :build
  end

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "make"
    end
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output("#{bin}/ski", "")
  end
end
