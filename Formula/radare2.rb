class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/4.5.1.tar.gz"
  sha256 "4e85b35987bd2ca5881ad9585970b970fe7374814bd383bd1cd62e961a0c228b"
  license "LGPL-3.0"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 "9467e9b55ca33ffa82183e3abaf14e3bf9011f325ead752f030358d1caf3aa06" => :catalina
    sha256 "029d3eb2338db6c3101cac9e1db31ddce50bbf5098251245b55fd3a9ee9cbfe7" => :mojave
    sha256 "c3affa5b3257049b811f60910ac3849c211bc99a4cd2489d11035e9379d87fa8" => :high_sierra
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
