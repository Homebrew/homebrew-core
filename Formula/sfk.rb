class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.1.2/sfk-1.9.1.tar.gz"
  version "1.9.1.2"
  sha256 "9c44787b5fadc2e8ddf6ef518ecf4a50784021f9438e83132a2411c3befd7c22"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7df98ea56af71c5179e3b7c9eb4c086fb7a464423799239a91ed3e4a55bd046" => :high_sierra
    sha256 "ad56046d7cd1b5809be38cde43d524480b414225155828705bf1b88b1bf8f9d4" => :sierra
    sha256 "7c451c8c18f3075b179aa21551b4ac48208c78645786956752d976427bdba364" => :el_capitan
  end

  def install
    ENV.libstdcxx

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
