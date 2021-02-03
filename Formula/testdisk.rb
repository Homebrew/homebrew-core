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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4c61e6cdb6119dacda42b08e912bdaa5a08dc380e40c6d80de5c1a1b7e60d48"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa46e925f4438d7f9cb855efd07499daa5622b331a8b16a22684633650d7315d"
    sha256 cellar: :any_skip_relocation, catalina:      "66c4088c77794a244fd5b38fa39216eb8d6a09b9e4efd5e68a249e9b5df65606"
    sha256 cellar: :any_skip_relocation, mojave:        "1e77fbc276d986fcf378901b2ba0d5957f17b569e512980017ecd09926505a4a"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8cd43adea2ddf632e5c9305609cf377b47fcf5836805075d06dd3ccd2142ccc6"
    sha256 cellar: :any_skip_relocation, sierra:        "752a686f8fa7717cbbdef064eefd80503eccdddfc587bd48fd24256e23332470"
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
