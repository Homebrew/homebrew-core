class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https://github.com/jpoliv/wakeonlan"
  url "https://github.com/jpoliv/wakeonlan/archive/wakeonlan-0.41.tar.gz"
  sha256 "1d8c3cd106f515167e49134abb8209af891ca152a00ee94a8c5137f654e079bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "017f70ad18520de448fa1e31d0e53d4b52ad548518da6923808b85d850bf3ee4" => :catalina
    sha256 "5fc2054a08a4ce9d08b5d004917acb1b57b198611f693503fca252550778a90b" => :mojave
    sha256 "876e4fd4919523eb2db07159a7c7d82fa30bec74972f0ef69c55588831db8a4d" => :high_sierra
    sha256 "2cb19ca9617f87fc2c14536434f17b44174336a739fed3ad83404ccfb412ee31" => :sierra
    sha256 "7da7f512ae921016be21fa3899d4f01841e3da5bc96570fcd85b530e4e720c06" => :el_capitan
    sha256 "78a5d905b250ddb09cc3fa4296f2ffc8c925788a7d8e5d05e96f5581e81a7e9d" => :yosemite
    sha256 "0669ec3967a728dd2962727896711f418556491ad172483240e84110843998e0" => :mavericks
  end

  def install
    system "perl", "Makefile.PL"
    system "make"
    bin.install "blib/script/wakeonlan"
    man1.install "blib/man1/wakeonlan.1"
  end

  test do
    system "#{bin}/wakeonlan", "--version"
  end
end
