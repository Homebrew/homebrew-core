class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.9.0/sfk-1.8.9.tar.gz"
  sha256 "0f974f491d28bf5442d94f9ddeb983bfc69ead96842965ad55152969381fcd8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2aabf3e4734a31ea5dd41eff8a71f02b2e367b6333801419491b110282f0189" => :high_sierra
    sha256 "229f03e71a523bfae5a9e0e31a02b129cc776341dbef63272e95b2fa05bdd71e" => :sierra
    sha256 "488fecfe38e50e08a722d4857fa4f4ce91f816930f016294a5d7a6c82d5cc452" => :el_capitan
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
