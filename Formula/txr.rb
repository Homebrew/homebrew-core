class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-198.tar.bz2"
  sha256 "82f53cd14b2cd60a9d0faed49ca14d42f5e212d2f05310c54b8a041a9d28ebf4"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "c771779e8d7017dfcfbc3cc40e96d2aa0a703bba18e0c19f52373aaa8bfdba52" => :high_sierra
    sha256 "133f30759d1d01b0d8c1a93db0d0c1da9af0b0e07bd426d549819b3566517f50" => :sierra
    sha256 "916f2f1be1a65b004d694717e28a39aec865d72d44d1d6e9c854364b79425e69" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
