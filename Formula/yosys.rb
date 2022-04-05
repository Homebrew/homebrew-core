class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.16.tar.gz"
  sha256 "c7a161e5f567b853a18be8417b60d31ce77804994dafc93306b897ddc335aa3c"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "5e63b69e211a427390ecce46654db44cd41b149814aef7dd94a7e9e2f167619a"
    sha256 arm64_big_sur:  "79e186372603cf019fafb01c1c9fbb9060642661d0a9714a8f837f3cd17da6ef"
    sha256 monterey:       "0b4972b9cdaf1aa9dac8da8f90c3b050a8a3cb0ba7a8610f0ed3d29ee9fa094c"
    sha256 big_sur:        "37679369e072785bfe3c44d1619ae3a49c3dc6a6f9da0332c400dd0121881304"
    sha256 catalina:       "5024f8c47cda4703c3e8598007d545708b28ceb6f0b2f6f9ef86ecadf0262242"
    sha256 x86_64_linux:   "3b8d615341c3b7fe7f8e00cff0d196aaab62c4a4cb530bff32a8feb1dcd7420e"
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
