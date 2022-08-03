class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.20.tar.gz"
  sha256 "ee261487badf1b554616d555da8496a7c84ef21ae66a979ddd946b6949a780a4"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "34d842e95d993376342a0f349161c4be681aff09b57852d78dcd9d2336efcc13"
    sha256 arm64_big_sur:  "a78f3eb42563d9af6bf94fa442a68afce7e6b36d9efa2004be2874b45a11c313"
    sha256 monterey:       "5c207f16b7420f96a63f1519ba0ce703b5c06c3e4cbe9bf8e10c319c12b45ffb"
    sha256 big_sur:        "76b8d97761b0ead87e40aa515579b77f77af6f740d54ff7a393db7ef45e87dcd"
    sha256 catalina:       "05e30f9466af45da7bd404bb464df40c2d7af5c66760119fbd5756fba7652bb7"
    sha256 x86_64_linux:   "01249f327579d0c39ade5acf2a213cd3f71dcb417160214ab2abf5749d41fe9c"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python@3.10"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
