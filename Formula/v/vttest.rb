class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20230201.tgz", using: :homebrew_curl
  sha256 "27f4300791e7cbcf9d15f88421f98e35d3aee66311368430624e2c1a5a8be683"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c58e9a5d89c0842b7c6cd517e751fec2d4eff1c2497dc2aa19bd999d7ec5067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c1b96ad11fbd55c8422fbc673dd5b37cb2c96c930df4050c4b242277b43a42b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e19cdd9aad8891b4db2271d271c18eb8f2baa64936037a7cb39601a9b7762ab"
    sha256 cellar: :any_skip_relocation, ventura:        "b3d455d8885635e0bfb84636feadbb4e04c3dfc3bfb22dfcd1804232a903c2fb"
    sha256 cellar: :any_skip_relocation, monterey:       "7a3fc4297a8d5a65e58b98027136a3eb899f8b99c6ce4b4b7d5c67c679228c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d5ab361b7e05cc501f049ee4e6d6c17108740d42768703d87fe710e1abe8d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75775c9b71dafab2ea0f580d212cce3e1a8d843df6f3560ce452879fedabab25"
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
