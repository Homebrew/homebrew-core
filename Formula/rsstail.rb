class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "https://www.vanheusden.com/rsstail/"
  url "https://www.vanheusden.com/rsstail/rsstail-2.1.tgz"
  sha256 "42cb452178b21c15c470bafbe5b8b5339a7fb5b980bf8d93d36af89864776e71"

  head "https://github.com/flok99/rsstail.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fb3c48324e30829c9fdd8e3199db2a603edd19154c5e69b48ada19fef0349ed5" => :high_sierra
    sha256 "9737f574d1c6d123b9c215dfdcd6eda682e9c46b76728b0e7e3cf1b523c5d53a" => :sierra
    sha256 "e19aec49f4d56c6f9c062f3a107c2e55c470de49ee760c8087d9b432aaea796f" => :el_capitan
    sha256 "e118045780d62ac16ef413fe826be97afadd48390d6bba5b0d1ad221291507bb" => :yosemite
    sha256 "98f3b9fee8f7dc9e48a141bc9347c4a23eeca1ede249f5763a73835539c485db" => :mavericks
  end

  depends_on "libmrss"

  resource "libiconv_hook" do
    url "https://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/liba/libapache-mod-encoding/libapache-mod-encoding_0.0.20021209.orig.tar.gz"
    sha256 "1319b3cffd60982f0c739be18f816be77e3af46cd9039ac54417c1219518cf89"
  end

  def install
    (buildpath/"libiconv_hook").install resource("libiconv_hook")
    cd "libiconv_hook/lib" do
      system "./configure", "--disable-shared"
      system "make"
    end

    system "make", "LDFLAGS=-liconv -liconv_hook -lmrss -L#{buildpath}/libiconv_hook/lib/.libs"
    man1.install "rsstail.1"
    bin.install "rsstail"
  end

  test do
    assert_match(/^Title: \d+: "[A-Za-z0-9 ]+"$/,
                 shell_output("#{bin}/rsstail -1u http://feed.nashownotes.com/rss.xml"))
  end
end
