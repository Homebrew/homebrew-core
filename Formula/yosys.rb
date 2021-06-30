class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.10.tar.gz"
  sha256 "eeec77e1983fd978fbff0257c4f4fb0d9bc07e403a13b9fc467878df3467b191"
  license "ISC"
  revision 1
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "4c08553d2fe432da88fdee962342d24e70013a9c77115c0d11e14499b33c93e8"
    sha256 big_sur:       "20a8b72ea5eea5fb9d3fc8a389bcdb4c054ddac7748f6dca79607b758cc633c4"
    sha256 catalina:      "6fb54383e9cae9397f0ed820d819669e2449f259bd5a30e62e549efe58251252"
    sha256 mojave:        "ba794845f034e803e56eea999c40d784530ae98a3600bb3f12e4fb97140eca9c"
    sha256 x86_64_linux:  "80d4eac488cb5930ccf9bc2db16ff11551246dac86d1e5968c8d9d5e70b270d7"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python@3.9"
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
