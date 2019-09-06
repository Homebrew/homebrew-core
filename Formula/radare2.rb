class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://radare.mikelloc.com/get/3.6.0/radare2-3.6.0.tar.gz"
  sha256 "21f3aa7573bd229d15c56322ecae12b4597bf6db4831a91224c8f86b2cd0bad0"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "ada8679faa49b7edebb271c4b0e587495262bbfcfbe1b85cd67970443c0c9088" => :mojave
    sha256 "fdb529956f72d3236dfc6a40d1d2736a314ceea09f2a1a7d2300ae7ca2db9b81" => :high_sierra
    sha256 "ae93a39352efc321199286005dfbaedad2ccca3f8ad07b48958c82536a269555" => :sierra
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
