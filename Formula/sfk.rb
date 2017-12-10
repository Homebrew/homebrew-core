class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.9.0/sfk-1.8.9.tar.gz"
  sha256 "0f974f491d28bf5442d94f9ddeb983bfc69ead96842965ad55152969381fcd8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4be767422ed9a90cd6298a6525d3957be2a9de56bd16fa461fc239bdb0878259" => :high_sierra
    sha256 "2861fbe744b3b3dc67ada77dc6d2b200cd4bebdb0b7f9af3933275eec6455c5b" => :sierra
    sha256 "f426a218d0178df2d4615392bf833628d6a0298c7e5038a2b25cb33b86a3e1f2" => :el_capitan
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
