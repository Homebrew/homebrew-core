class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.5/sfk-1.8.5.tar.gz"
  sha256 "294bc3f3fc4318a198da47d48ebe38652d57bb0dee2c11fa9c0025d3d8ad9dc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c7e7ae2363eabeac65d00ca5eef0000b833a4292ac04e6a65eb463e943a99c8" => :sierra
    sha256 "2381b06258528bf09b607565253fa5de283c2e8de62851f9d6561f1740d1a7f8" => :el_capitan
    sha256 "cf8b51a51b311491b92366b1a4fd10141d06809ed08a3f7070c3c4f1fd64d558" => :yosemite
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
