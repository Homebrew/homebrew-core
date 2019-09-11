class Testdisk < Formula
  desc "Powerful free data recovery utility"
  homepage "https://www.cgsecurity.org/wiki/TestDisk"
  url "https://www.cgsecurity.org/testdisk-7.1.tar.bz2"
  sha256 "1413c47569e48c5b22653b943d48136cb228abcbd6f03da109c4df63382190fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e77fbc276d986fcf378901b2ba0d5957f17b569e512980017ecd09926505a4a" => :mojave
    sha256 "8cd43adea2ddf632e5c9305609cf377b47fcf5836805075d06dd3ccd2142ccc6" => :high_sierra
    sha256 "752a686f8fa7717cbbdef064eefd80503eccdddfc587bd48fd24256e23332470" => :sierra
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
