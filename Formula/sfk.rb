class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.6.0/sfk-1.9.6.tar.gz"
  version "1.9.6.0"
  sha256 "3d501fc9d54b10ad31144db97978087346042fb519feb5a5be06cf3f7ef5f081"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b9c2addd71a6703f7c7f75f38368ebf37ba06af3161b06c4bdadc2179d79e0c" => :catalina
    sha256 "27cd6edcb20275bddc23f7cd405788191745f5721d8f974064eabbdaee1c4011" => :mojave
    sha256 "ff756db64c5e9d78cb01aa8f2645b4e23ccf0784d34b06e1b8a1f690c365d6bd" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
