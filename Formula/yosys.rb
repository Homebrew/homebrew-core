class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.28.tar.gz"
  sha256 "36048ef3493ab43cfaac0bb89fa405715b22acd3927bf7fd3c4b25f8ad541c22"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "92f9308b3a34a9f6428e6ebc39a62353990646d663cb4862f4d00a6da5f83ad1"
    sha256 arm64_monterey: "407050dbd42aeb86ed98c9dc0b573e08f40920d336ad38e589d9479cd09eb971"
    sha256 arm64_big_sur:  "7facf0f980e5b65032f116a27c2ea29e6f357e3cd93612b26205ff98fa09cd5c"
    sha256 ventura:        "cc6c62bdccfb3a41ead49e31c27ca62700b658ce3f2fbacc574fd479885bbfdc"
    sha256 monterey:       "1c61e5355051a115ce471beb769c83e493815c2d69cf70b9b5f1fa3655294d6d"
    sha256 big_sur:        "175585e3f31042894308661430fc0a89264837cd2776c306c45afba0a433a4e9"
    sha256 x86_64_linux:   "4086e95dc334cf5c5ea4343f31d0de9b0df8c0cd1d4e6cfd32a8a4079f20f978"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
