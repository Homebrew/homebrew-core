class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  # pull from git tag to get submodules
  url "https://github.com/YosysHQ/yosys.git",
      tag:      "yosys-0.42",
      revision: "9b6afcf3f83fea413b57c3790c25ba43b9914ce2"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "87929810524bfce1c2496275e46fbad619f808f80894c3d85cc95d6483f02493"
    sha256 arm64_ventura:  "19b8543e8139e22d27e9965a0007d4d9f55e530109803635d23a3df28b1c492a"
    sha256 arm64_monterey: "54fb0fa2d5a0865eb4fbbeb14d8357b4b9fa7b0525648a25ac2f1fe961fffb95"
    sha256 sonoma:         "5aae842ea046641bd53571a8e85ad1d250ae6eb9a8a53ae4657bae3fc91affbe"
    sha256 ventura:        "73951e88c2577444017d1efe8c7b05a91727f4defcbcfb6f40cb2dae13cb2a41"
    sha256 monterey:       "951852d544f7eb8b6bfb1dd2cdce5c183ab0788b368b9e867d323d04042f5a7a"
    sha256 x86_64_linux:   "1f08e3b4a9e12e758af43fcd3ff171405dad8ccdf1e4bbe3305f788b934baec6"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
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
