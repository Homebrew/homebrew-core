class Testdisk < Formula
  desc "Powerful free data recovery utility"
  homepage "https://www.cgsecurity.org/wiki/TestDisk"
  url "https://www.cgsecurity.org/testdisk-7.1.tar.bz2"
  sha256 "1413c47569e48c5b22653b943d48136cb228abcbd6f03da109c4df63382190fe"
  license "GPL-2.0"

  livecheck do
    url "https://www.cgsecurity.org/wiki/TestDisk_Download"
    regex(/href=.*?testdisk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b8a4f36f57b849119b447259f492466b2d297d9f178643875dc709a2abe419"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02338490d4e16fa0a61e422ec36ce72e97ad1d24406cda45f4d61396ba4cab36"
    sha256 cellar: :any_skip_relocation, monterey:       "bc5bf54d38d9f237ac6de913cdf9f841e77876b63f69c5f0b380f9f095242d2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "325a572e2238e551d8415f58a463d80619850a9026b614d0c23da46838f2e9ea"
    sha256 cellar: :any_skip_relocation, catalina:       "b0035f42c03dbbe94000ae373b1a8c5f9bbb6f9534ea3d64b5754475ee8fbc7b"
    sha256 cellar: :any_skip_relocation, mojave:         "7431beee8948638cadaf5b7f439e32f798955caf403fdcfda5c9948afa5af3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d22006b793a33a7cde952b4323410fea06ab20d49126159eccc6d187c7d0061"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
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
    cp test_fixtures(path + ".gz"), path + ".gz"
    system "gunzip", path
    system "#{bin}/testdisk", "/list", path
  end
end
