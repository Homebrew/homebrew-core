class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2.0.tar.gz"
  sha256 "d7032f607e8913c019b190c2bccc36ea73fc36718ee38b5cdfc4e4c0a04ce9a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "897bd1fbeafaa08b89e08a10dc4ff1b50b9b06b2a4538931b7412e5db2d0e4c2"
    sha256 cellar: :any,                 arm64_big_sur:  "ae13ab78f1010493141f38f2671a7908545f7144dc266cef4cf78512944f3695"
    sha256 cellar: :any,                 monterey:       "37ede6a5295e6feca3bb8661d21bc306bc6362cdffa096c28ac1232cbc437710"
    sha256 cellar: :any,                 big_sur:        "6b26ef894b7ecee4b8f4fdbb4415810c25e73cd1ca4c5d4a5040d76b1f7d1d0d"
    sha256 cellar: :any,                 catalina:       "84c7225a9ee78c41bd858d8b52d01a12db6ba358826e45bdc30e42d9e802425c"
    sha256 cellar: :any,                 mojave:         "0d61efd09b255e0856833e51bdbdaabcaaa325824a71ec326da61ffd8e200675"
    sha256 cellar: :any,                 high_sierra:    "7473fce6835c55f0547e60ff32b9ee1d16c2d3a490f618310dd276e34126bd1f"
    sha256 cellar: :any,                 sierra:         "b96155ea177b81d37a86a9b57dc38643680bbf6b22a6a2b826734f3cb2b5aa93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c96d341edd8ec2003fa0474786591d074bdae8677a8c664ba73b7debb669b64f"
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
