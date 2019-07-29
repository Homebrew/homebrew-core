class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2rc3.tar.gz"
  sha256 "e8be7482df7c95735e5466efb371bd7f21115f39eb45c20ab7264d39c57b6413"

  bottle do
    cellar :any
    sha256 "976f26d11b921a994d65f4f1d911e7b181ee19107c6c591613bcd23eb5e0077d" => :mojave
    sha256 "4a56292d0a64f7e1e9f9227d6c6aff652e6de5263cf7ba1a3d571321ee5cea09" => :high_sierra
    sha256 "367e34d4ba6e7087762193a18910da38905496ec41c0f329604d310a09e4f5ed" => :sierra
    sha256 "4891bd2a89fc9369d9c573afd80a1e7593e9414a0d6a956921af1b65f61ab264" => :el_capitan
    sha256 "34a342effdc414829a7063d4b8dc7f2bbfa2d37231904f4fa6784c38d90bdb3d" => :yosemite
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
