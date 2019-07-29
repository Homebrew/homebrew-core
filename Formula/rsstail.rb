class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "https://www.vanheusden.com/rsstail/"
  url "https://www.vanheusden.com/rsstail/rsstail-2.1.tgz"
  sha256 "42cb452178b21c15c470bafbe5b8b5339a7fb5b980bf8d93d36af89864776e71"
  head "https://github.com/flok99/rsstail.git"

  bottle do
    cellar :any
    sha256 "043bb4c59d45bf3d10e8a80c16dd684267c7ee905fd3384d6f197dff9d9ca686" => :mojave
    sha256 "972ee73523d6f2f90ad8cefea3be3d800ed56ef86f5ab0aa27a9868959e8c4f6" => :high_sierra
    sha256 "288a7d9668a50fc1db8525be5c1ef3a932e134b095bb6d0b5a785353ca8b6d59" => :sierra
    sha256 "671b60685eabd26014203b5cd2eff8a94ee940e139c77793b379e1114c23a912" => :el_capitan
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
    assert_match(/^Title: /,
                 shell_output("#{bin}/rsstail -1u https://developer.apple.com/news/rss/news.rss"))
  end
end
