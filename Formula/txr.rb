class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-196.tar.bz2"
  sha256 "76cf34c891d4c7026fabac32f82ac7137321495f433a32a75145f7fa9ca167ec"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "8073b36ff119e61e5d42fe7e0ec359943b468ae4b25c7cb067eb103822c1cfe3" => :high_sierra
    sha256 "3e773409ee776bee2cc4a0b82a337629bed1061c958894dc6d0006da98908c4e" => :sierra
    sha256 "7a8a5be2a66b20d8e307fc9f9e9c2d66c7f004d69b7161795c5de13865b4d824" => :el_capitan
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
