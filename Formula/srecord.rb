class Srecord < Formula
  desc "Tools for manipulating EPROM load files"
  homepage "https://srecord.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/srecord/srecord/1.64/srecord-1.64.tar.gz"
  sha256 "49a4418733c508c03ad79a29e95acec9a2fbc4c7306131d2a8f5ef32012e67e2"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea6f0e094cd533b6e4a1edd1be1dca4ccfb1386203fbde1e50d9868cd6145793"
    sha256 cellar: :any,                 arm64_big_sur:  "2531dde4b69ae50e0cb15b498b2729862e64d00b98be831e581989d9e907f36a"
    sha256 cellar: :any,                 monterey:       "00588bcdaa60466ebedf0f60caec0c94c21447640b6df81c0dac9b83e9f63057"
    sha256 cellar: :any,                 big_sur:        "5c5129ae228ef644b5ed2a26516295feabd198aea270eab03c5c6d3e418980b1"
    sha256 cellar: :any,                 catalina:       "cc4e1e89835954876853f5f7bcccbfd172adbb5651c1f2790ea3da10e4347845"
    sha256 cellar: :any,                 mojave:         "6b3b825b501d1ea1635d107fb62021dde713f6da375f53f1a1fdcb59070df63a"
    sha256 cellar: :any,                 high_sierra:    "f6341ba9022e6cbc057c519fcdc7c7518247c850025777b80d2463341315d88c"
    sha256 cellar: :any,                 sierra:         "0601896fc392a13f7ef861fc3840fadfc7ddc7313763c1d374555129f4301c0d"
    sha256 cellar: :any,                 el_capitan:     "6a0df3e5fb40699d9b1198562b3b3a4e1745c3a0d12923c461246b7784b8324c"
    sha256 cellar: :any,                 yosemite:       "c3c29b357c44bc3da2dbb8f23a6d83aeb637aa374fe0564eb9454e5e6b53d54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ccca42765c5c335dd26b2be5ad0a30b95d279e59958c89950d8cdbb5321816f"
  end

  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "libgcrypt"

  uses_from_macos "groff" => :build

  # Use macOS's pstopdf
  on_macos do
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/srecord/1.64.patch"
      sha256 "140e032d0ffe921c94b19145e5904538233423ab7dc03a9c3c90bf434de4dd03"
    end
  end

  on_linux do
    depends_on "ghostscript" => :build # for ps2pdf
  end

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make", "install"
  end
end
