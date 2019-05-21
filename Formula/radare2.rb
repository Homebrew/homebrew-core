class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://radare.mikelloc.com/get/3.5.1/radare2-3.5.1.tar.gz"
  sha256 "bc927aec4d29fa647fdc56afc2d7b04bf47c2234a43d0080f356705748299d9c"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "2e54078d5cff62cd5593ba2390a0f230e334b94024954e5b6329d52c0401aafc" => :mojave
    sha256 "18dad4749aba2e1d3b5ecb55a1b3c55656bf0e604fc6e739b45a249809053a98" => :high_sierra
    sha256 "67705968143b7235843ad4a494ffca8bbfb886168656a4171bb730dec615a0d2" => :sierra
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
