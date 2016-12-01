class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "http://scale2x.sourceforge.net"
  url "https://downloads.sourceforge.net/project/scale2x/scale2x/3.1/scale2x-3.1.tar.gz"
  sha256 "afdd88b90811b00ae884eb8a97355991f39d8028dbd5c6b1d95fdccf0fc56574"

  bottle do
    cellar :any
    sha256 "682fee40f32660f8123e06a0c918895a14515517e7fb1dcc6eb362fe1a870c4a" => :sierra
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}", "CPPFLAGS=-I/usr/include/malloc/"
    system "make", "install"
  end
end
