class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "https://www.vanheusden.com/rsstail/"
  url "https://www.vanheusden.com/rsstail/rsstail-2.1.tgz"
  sha256 "42cb452178b21c15c470bafbe5b8b5339a7fb5b980bf8d93d36af89864776e71"
  license "GPL-2.0"
  head "https://github.com/flok99/rsstail.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "6316d9202a28175cb6e2f8451402db38f9d11a581145459ce6e10a49a2096e1c"
    sha256 cellar: :any, big_sur:       "be1e378b0c375b4087bf57bcb1c97d94eddb25fccf55587a732ff6cd5f1fdc72"
    sha256 cellar: :any, catalina:      "253a99c8187e0dc6fb29049273f08dd4b199c0de1e9171c4a0829f21aaf5c90f"
    sha256 cellar: :any, mojave:        "b6f2a222c1bc903a5d0179331398ced65980798d694d186bd52e0b54239d9dfd"
    sha256 cellar: :any, high_sierra:   "29b1cd5b6cbfbd66d250586450e2e24e5706da80b03aa1b54834bd0c01e73202"
  end

  disable! date: "2022-10-19", because: :repo_removed

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
