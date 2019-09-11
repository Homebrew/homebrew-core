class Testdisk < Formula
  desc "Powerful free data recovery utility"
  homepage "https://www.cgsecurity.org/wiki/TestDisk"
  url "https://www.cgsecurity.org/testdisk-7.1.tar.bz2"
  sha256 "1413c47569e48c5b22653b943d48136cb228abcbd6f03da109c4df63382190fe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2c605aa973b201cd63a19efa53a7748a629b860b48f452db6c2ea61856d6aea3" => :mojave
    sha256 "e2643fdb09f3d33b18fb181590fe5fc58f9117a8a02791eb55ba5cce998b6cb0" => :high_sierra
    sha256 "30784b33a74eaa138c16ddc7cbe56bc542f19759a87cfdea37084691ba5788b4" => :sierra
    sha256 "979d1f6ba12aeee68300a657a78a234874707068232934d7f91597621a60253e" => :el_capitan
    sha256 "13f6481decb5ad3f40f0617351dd9c78a02c3c0694a82cb048adde6ba897703f" => :yosemite
    sha256 "d3e8a600a135807b630a4d649c052dc6065270910bd96f6b1f27265251787331" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = "test.dmg"
    system "hdiutil", "create", "-megabytes", "10", path
    system "#{bin}/testdisk", "/list", path
  end
end
