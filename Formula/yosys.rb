class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.19.tar.gz"
  sha256 "d527fd88a9f7101c6f8e37889b14add0b6d2c74c2c611295f3813db4f397518f"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "2f1bd2a06d7f85d16f23b01f4cbb41632d73d923da89c8e856c9dd540bd73811"
    sha256 arm64_big_sur:  "c4d1e4db9d00c6238511a7cae6d69d591a58eeabe5d0f8cd92cd1edcf2c98713"
    sha256 monterey:       "56575ec93538e5dd5dc5cc34a0ee6320c64610d26dbd2a456cc635542a1bbe70"
    sha256 big_sur:        "41fb922a2847096bf16ef25618f840ee7f094b0df3a1232156396d02f0611e6d"
    sha256 catalina:       "70cfae07442c3e3d44e3b27da049fe1161b5bd6c00e13631a581d9f68ea914d5"
    sha256 x86_64_linux:   "6b247c3998a06759b2d66d17dafa14b22f3ce406702bfa2175a8e514f813a39c"
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
