class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.5.2/sfk-1.9.5.tar.gz"
  version "1.9.5.2"
  sha256 "0c9596d0271cc5c04d91c99f53ff17d5bf566187512f0e51f9fb2e4f4a44d152"

  bottle do
    cellar :any_skip_relocation
    sha256 "31be7680a1df8fa2fb4de468fc67e8393aad87c8919cf3b9c08bac70b3c05ba1" => :high_sierra
    sha256 "42cd7ac69141a671fa741ff9ca9b4dacaa4530ed9e2c969f91803b68ed6167c8" => :sierra
    sha256 "151596ee2a4392118faf49ed6b56f7b4408ea800d6e212afc6c67941690b735d" => :el_capitan
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
