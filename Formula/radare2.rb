class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://radare.mikelloc.com/get/3.6.0/radare2-3.6.0.tar.gz"
  sha256 "21f3aa7573bd229d15c56322ecae12b4597bf6db4831a91224c8f86b2cd0bad0"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "0ef7a91ce4b25b3b5eaced6755e41b73cccb4a8aace4f2a6e0ca86faf4e8d0ce" => :mojave
    sha256 "864612e414d3aaf8c77e2f0f63abb2b3517fc46a2d5b5c947429252cef24a12b" => :high_sierra
    sha256 "f097dca460f7578ffeeb16055bc432b67c8d9fb9e8b5c2f802d9134ba6947622" => :sierra
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
