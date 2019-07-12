class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://radare.mikelloc.com/get/3.6.0/radare2-3.6.0.tar.gz"
  sha256 "21f3aa7573bd229d15c56322ecae12b4597bf6db4831a91224c8f86b2cd0bad0"
  head "https://github.com/radare/radare2.git"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
