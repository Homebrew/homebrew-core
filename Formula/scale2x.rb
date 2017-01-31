class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "http://scale2x.sourceforge.net"
  url "https://downloads.sourceforge.net/project/scale2x/scale2x/3.1/scale2x-3.1.tar.gz"
  sha256 "afdd88b90811b00ae884eb8a97355991f39d8028dbd5c6b1d95fdccf0fc56574"

  bottle do
    cellar :any
    sha256 "8699587cf81a5d38985d81e32bb7b7815cda1d731a5f134d045692b5276e0a12" => :sierra
    sha256 "ad49eb9e6167e9ad5d5ea4f08a870b06ee9118465668762ac05a8b50cdbd7ebf" => :el_capitan
    sha256 "c431a4d6ccc671f7d010fc1d010d6f31372c2075942ffc402f7969f7b0c7b43a" => :yosemite
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}", "CPPFLAGS=-I/usr/include/malloc/"
    system "make", "install"
  end
end
