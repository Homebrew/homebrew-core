class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.3.0.tar.gz"
  sha256 "8d99d799ab78847095aa501427b4e8b19ee600dd53b26edf546aaf84d1cb4ed7"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 arm64_big_sur: "1f45c3a96040a660ef2de272c9f46378587d20f6067a7f2b9749a307b52079f0"
    sha256 big_sur:       "3a1ff714c7e9db0488102ad7728ea475a20758b28663c8c01e7ee0e12367edd4"
    sha256 catalina:      "ddacf5e9ff5600929694b63a85648d27b5752dfdab2e82e39fe3f123f49d9258"
    sha256 mojave:        "dad8e41a3bccdad7eacec3be1bf1b23c731d3d9d039719c284da25c21a2f3118"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
