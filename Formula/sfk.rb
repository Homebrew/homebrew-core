class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.6.0/sfk-1.9.6.tar.gz"
  version "1.9.6.0"
  sha256 "3d501fc9d54b10ad31144db97978087346042fb519feb5a5be06cf3f7ef5f081"

  bottle do
    cellar :any_skip_relocation
    sha256 "01a8fdc14835ec662924df0ec6772afa80585e78ff92d58e92596d84e18e0d99" => :catalina
    sha256 "c8ba1f86897c1091d54528e2d3e1269ab140197b86c4eaea47ac5aa39d7bf2cd" => :mojave
    sha256 "47d8b16e909564e1f04667c725c0a0ae4668f915af7528646e37d03f9ec9f021" => :high_sierra
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
