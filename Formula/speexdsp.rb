class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2.0.tar.gz"
  sha256 "d7032f607e8913c019b190c2bccc36ea73fc36718ee38b5cdfc4e4c0a04ce9a4"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "6b26ef894b7ecee4b8f4fdbb4415810c25e73cd1ca4c5d4a5040d76b1f7d1d0d" => :big_sur
    sha256 "ae13ab78f1010493141f38f2671a7908545f7144dc266cef4cf78512944f3695" => :arm64_big_sur
    sha256 "84c7225a9ee78c41bd858d8b52d01a12db6ba358826e45bdc30e42d9e802425c" => :catalina
    sha256 "0d61efd09b255e0856833e51bdbdaabcaaa325824a71ec326da61ffd8e200675" => :mojave
    sha256 "7473fce6835c55f0547e60ff32b9ee1d16c2d3a490f618310dd276e34126bd1f" => :high_sierra
    sha256 "b96155ea177b81d37a86a9b57dc38643680bbf6b22a6a2b826734f3cb2b5aa93" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
