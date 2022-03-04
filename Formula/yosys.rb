class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.15.tar.gz"
  sha256 "a40fcc487d2a31c2abc6f61d39a84e262f2650e40de479542bbde317308c4612"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "65fb3b85a45695f72ed44730e27da8b4910a0cde269574017037beb0f107c4bc"
    sha256 arm64_big_sur:  "a6477367178c2a98bd194d79872bed34cd64e5e91aa5bbd7e9d1eee8692f15e8"
    sha256 monterey:       "9a68e6464ea816cc24fdf2a2d28fb1c88a3c3dbb35baa167178215fa40f3a7d2"
    sha256 big_sur:        "22fa7c905ca72c935c1cb8501d1f03f83bc4d614bef18492e146d9e72d8e9e0a"
    sha256 catalina:       "d2cc79d8d097bde7c0191fb8d5af0991f3174fc527067ac132248790e509637d"
    sha256 x86_64_linux:   "9601025166b57f2c24004af72e91a6d0c464d3b1b750a4e0132ae4c770dc6d1a"
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
