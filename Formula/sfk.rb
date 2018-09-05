class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.2.0/sfk-1.9.2.tar.gz"
  version "1.9.2.0"
  sha256 "4537d033edfe6feb0bbafdcf157646a19951b8ef9056898718674d39a3c088d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "31be7680a1df8fa2fb4de468fc67e8393aad87c8919cf3b9c08bac70b3c05ba1" => :high_sierra
    sha256 "42cd7ac69141a671fa741ff9ca9b4dacaa4530ed9e2c969f91803b68ed6167c8" => :sierra
    sha256 "151596ee2a4392118faf49ed6b56f7b4408ea800d6e212afc6c67941690b735d" => :el_capitan
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
