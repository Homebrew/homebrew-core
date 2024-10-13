class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/5.9.6.tar.gz"
  sha256 "91a4475c16eb17015080b9b688e17e666d1982b0727e7aea71ddf0a7ad2ccd0d"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "47a5abc67bab58fb2ce318cc19cda15520c09811fa41e9388847f667262ffa23"
    sha256 arm64_sonoma:  "c3060d2a9a70319d371d1f9d2c652e10fab831bb33cbebca655b580b4ecbb369"
    sha256 arm64_ventura: "eeca1fe9040678fb496ceab78d8c4b69458a3736f64b1719974f4d565921659c"
    sha256 sonoma:        "5447f90f0def8d5823f67f52c83af6fa8f081370c4e7bf4fa4566717619f5d12"
    sha256 ventura:       "a4cdffb9cc15ced5a81f3b2ebdaa9a0327706b005baccbcdbadf201b451ee6a2"
    sha256 x86_64_linux:  "2b3dc8de9150c35073826cdb8f592411ffbd4aac65d70cc44c993245787714ca"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
