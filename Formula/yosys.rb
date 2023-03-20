class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.27.tar.gz"
  sha256 "bd6c933daf48c0929b4a9b3f75713d1f79c173be4bdb82fc5d2f5feb97f3668b"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "122c76365151eaa6c63a22aa75acb37b5720f498329f2f356e3f1a48d51bea61"
    sha256 arm64_monterey: "b1e4d32fa1d2f0bc677ff9a8bf62723162fe1f50ec5db1115a6af9aaf7a973ef"
    sha256 arm64_big_sur:  "1abb02f9f01973377f2b8452f436ef1efa40221e1dbe3e919ca8809274407456"
    sha256 ventura:        "f536cfd2abd9b9be028e69c60587173781e816a69a40e776a6af4612c5328ed4"
    sha256 monterey:       "6da219e55eb4a08a62d22ae2c5e6f19c3c0bb022781d8be709641fb08e65df57"
    sha256 big_sur:        "16db83731348d572f88ba5b7357cf66705bdda15dc3fdf3e067822a0eec49889"
    sha256 x86_64_linux:   "b8c9542a00a997f42a4704967229e948a142e17e1bbe9bd57acc56c2aaedee18"
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
