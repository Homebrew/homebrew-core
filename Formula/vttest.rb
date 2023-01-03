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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2dd94a17f085ba96fbaeecd627e176ec2f729325b9cf55f480dbf33fdc6fc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc8312b8bf5099264a66c4a5fc3c56e0e2f94acb965907daea3fa491af8ba2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca4a1f438087be63169b30aa6b5e8109ac4e3ac697a4f60b7e313d0c1cadca24"
    sha256 cellar: :any_skip_relocation, ventura:        "79b80372c767f77bfd8ea54da2d8dec00936b4723c7acde1c52328998bdcadbf"
    sha256 cellar: :any_skip_relocation, monterey:       "71dc9060748ed385f86878085a945d13b052206c6b2c3792735e6f8c9601c852"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eb45fe6c233bda2eae0f3759f845f550e44352ccb5a42f33c3e29dbd2897234"
    sha256 cellar: :any_skip_relocation, catalina:       "67a0537ebed546a7abacf0beb25e3bbb4b35a6032bcc69522b47de19445adb74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b4639eaeffc12b6ebf276ec03fde495a150ff5a03754386d65f135a633b8ae"
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
