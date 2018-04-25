class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "https://www.scale2x.it/"
  url "https://github.com/amadvance/scale2x/releases/download/v4.0/scale2x-4.0.tar.gz"
  sha256 "996f2673206c73fb57f0f5d0e094d3774f595f7e7e80fcca8cc045e8b4ba6d32"

  bottle do
    cellar :any
    sha256 "fd683dea067c68253aa4fe198438fc19f023bca3a368931bfebbbabb5032fd99" => :high_sierra
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
