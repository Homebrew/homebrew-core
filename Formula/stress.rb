class Stress < Formula
  desc "Tool to impose load on and stress test a computer system"
  homepage "https://github.com/resurrecting-open-source-projects/stress"
  url "https://github.com/resurrecting-open-source-projects/stress/archive/refs/tags/1.0.7.tar.gz"
  sha256 "cdaa56671506133e2ed8e1e318d793c2a21c4a00adc53f31ffdef1ece8ace0b1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "044a6885d230385e498d3ec58cfb69a660fd14c559b98f6f290011d8a0538e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "118778f167fc89bd644efa192610afb14e2943ffd337ddac936a8d28752dd839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61787e73298604cc4fe4639761fe50233e7a8ba3c9253f5e980e02b46daebd6d"
    sha256 cellar: :any_skip_relocation, ventura:        "695bfb124e1e5d77727d32ff213651860b3c7277abc90ed074b13ee646b199ee"
    sha256 cellar: :any_skip_relocation, monterey:       "bd39f786f17a6a6c521ac6a0aeefb86d9c8008e079ae836d3b7c71484b385bff"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e1a1ec5ec0b6ac13656605dff3de6f5d450077e36ed01203dbb5aac90aa87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c187c5ce03c3016b0d4a16674ec10005ee738e08907ad6dd1e576fd4b10903e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end
