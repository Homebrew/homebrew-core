class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20230924.tgz", using: :homebrew_curl
  sha256 "be8b07cb590976d1f42af8597ddadac808d08b0a268bb6304a887dab3f13a228"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c38ca10533212a69941f451ce745da46582d2acae416080c5a244c6cd93148d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fdc032c88caecc19386bcdbe4cd286900f252073b9ab265b6bdd7a89bc6d350"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2494b416f89baf84fef41ee54d269745925a7e12a3bc2dc90a1e2ee85330e7bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b68dc19065fd3b70210e19d3ea0476bf99a6528c3c2f1e07a62fce209697097f"
    sha256 cellar: :any_skip_relocation, sonoma:         "237947100856f61574275ed48fd9a4df1a3613fcfd6c00a228f50b50fa48d0a1"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca874e387023e80280118a4969f72f354350c18ea0ad9b219d8ce04fec344fc"
    sha256 cellar: :any_skip_relocation, monterey:       "22a2d88a01009efc9655cb6888748ff27d68a8435bbcfa6b153d722d2cf3bf8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a48b00cd0631ff1aa293051addcf656032cb82deffbc20ffd1fe350b19b90f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f2a402836344c5096351921b18b07e80378d33472e73a10443d7dcb01c27f99"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
