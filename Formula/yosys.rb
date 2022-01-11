class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.13.tar.gz"
  sha256 "004c203cb516887a8c76678a1fd76381198a8c46a17f4d893c34b7521df894b5"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "d81a1e6b5971460c44973f784cc4ef84a202c4b254b67fcbb007db2c62741c33"
    sha256 arm64_big_sur:  "e002b92c8b1c113c671e7e5397d9abff862cef18726f783b752314523fe06957"
    sha256 monterey:       "013e9f44355c047c1ea83dab8c53d744ee3b16ce9af637647ace4a6c2c554605"
    sha256 big_sur:        "1194d82d8e2c0f39c560294c7e2a798a4f3b1758f1760eadc6dc7c348abe4d3d"
    sha256 catalina:       "aa97c0ca02f2cb1da6eb49b4ed1baf98ac7cbc47402d345fca8e4ac1c9248928"
    sha256 x86_64_linux:   "04807cf0d621d4279f9f78d7e16c4017ff632129eccd8f8f36166b718da85589"
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
