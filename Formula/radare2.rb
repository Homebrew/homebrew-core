class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.6.2.tar.gz"
  sha256 "e1aa173b29f8c494e461b7a91022be33e6de6e15bf185e055fc999500e83bbac"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "a4a778f79057251475d9e56f3ad03f10623963d12c7c739c79fd7f4dcdd0e67a"
    sha256 arm64_big_sur:  "b2940ccbd2dad2a938da9ddc354da158d5f18c9a84b9fc4b69953491ea20f15b"
    sha256 monterey:       "a97fb345d055e7daa24686e3ff414105d29a0e58141a10b1fe2e91129fa61eee"
    sha256 big_sur:        "5fc3f8bf1210bf2344391c65141862ae8f58041f97eac9a138983f5ff381771a"
    sha256 catalina:       "8a67eaf3adf4d1982f30bb94a936856d5b284bf743ad651a40e3416e8a773d89"
    sha256 x86_64_linux:   "d0ebf326cf615abc5cc24a1247c688ba6063dc6bc32fd7f6ab29e36138d8eb76"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
