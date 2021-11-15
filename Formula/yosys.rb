class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.11.tar.gz"
  sha256 "56b98991b7833b5593d18c81fe02e922a3324bf581b7210ac7e7ca3fdcd9193e"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "bfc50cfc59cb10e87ed22a64c81f22146d6ab5dbf4da6077d7bbd3b33df4296c"
    sha256 arm64_big_sur:  "ef246ea3508f9cef89df7f73150bd3594b16c069bf8e0e6caf01ea6c8766d9af"
    sha256 monterey:       "e53a242cf85bd8947d5fc34e3c1a5e56438271a056871ae5b96d8ad4980af406"
    sha256 big_sur:        "6267c1a40a1ee92c4be72637e9164dcd8aa8ce1994d91030c934adc8ed23deb6"
    sha256 catalina:       "38f730623e17290bbdcacd4d5ff0e53a6579c3d5200c23a807a17efec9caf829"
    sha256 x86_64_linux:   "e3041800f9385f90248245838d00226e1494b9bc54c175440fcdb5a96e0b3b7c"
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
