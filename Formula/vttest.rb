class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20221229.tgz", using: :homebrew_curl
  sha256 "6b6a109acaf0569cf7660d20dcd153b83e328e9b93dae4e73b985bbcc6b18bf8"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9683bce2127f3bea130725dee58feec7ee5656063a700db7a1a3b85f89be253c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01082a64059912712edaabc53614a416f4f15a8b93bfd7f1516c95c5307b5cc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17c55267b9cadf6a5e966566d3d68956fd5eac851d755a3f198cd5b52d55420b"
    sha256 cellar: :any_skip_relocation, ventura:        "3769cd03caa60b6aaf7266e8384bd2e9c4f5ef766ddac40fff3d7e1ecec7ccac"
    sha256 cellar: :any_skip_relocation, monterey:       "f78bfb8dc24550a769c7c7ac48e3d6518f915660552905693d38dc9b79387cc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdcd6a9a887b69b444c2dcc43f573e5fc337b8b667add0e3b49ae1557e882d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "294646076af62801faaf1ed33541956b9f9c5ba92958775918a682b21262f465"
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
