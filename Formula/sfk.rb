class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.5.2/sfk-1.9.5.tar.gz"
  version "1.9.5.2"
  sha256 "0c9596d0271cc5c04d91c99f53ff17d5bf566187512f0e51f9fb2e4f4a44d152"

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
