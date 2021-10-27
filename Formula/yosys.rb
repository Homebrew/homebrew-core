class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.10.tar.gz"
  sha256 "eeec77e1983fd978fbff0257c4f4fb0d9bc07e403a13b9fc467878df3467b191"
  license "ISC"
  revision 2
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "6d57439e80cb30068203005e6e40502aef0f404b81b3dea7c4e3601706580e61"
    sha256 big_sur:       "a53171d3915947fdcd3070e7c889ad1a338302e4572c712e7dba03fa0ba4ed7e"
    sha256 catalina:      "a9963ff851b5caa4cd66e3108cfac5d7b06733b2f4f399500f261c090197450a"
    sha256 mojave:        "e5b72f1172bb2ef8ff6c9e91c2f88448c7501a2798ff925884f3faadd223f122"
    sha256 x86_64_linux:  "4d5ee0732dfe02830ee26ea4e8cd2a3613c62e928b6c0c2b39d2d176823dd513"
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
