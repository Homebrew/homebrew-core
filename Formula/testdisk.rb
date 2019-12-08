class Testdisk < Formula
  desc "Powerful free data recovery utility"
  homepage "https://www.cgsecurity.org/wiki/TestDisk"
  url "https://www.cgsecurity.org/testdisk-7.2-WIP.tar.bz2"
  sha256 "f661b4e4ffd973d9685c0c0fce8016a8086ccdfedb249c14b24017943f40b3ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "66c4088c77794a244fd5b38fa39216eb8d6a09b9e4efd5e68a249e9b5df65606" => :catalina
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
