class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.10.tar.gz"
  sha256 "eeec77e1983fd978fbff0257c4f4fb0d9bc07e403a13b9fc467878df3467b191"
  license "ISC"
  revision 1
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "ab618b2bc9e7dd869b0cc5f098fa9d6791f6307e160dc7c81fce4529e090f4b7"
    sha256 big_sur:       "286c62d0080ee503fc2fe3d6f32440e1d2566d0d069cf09f534773652cce8469"
    sha256 catalina:      "0e24c758cb8bb68c566392144ea9c388c2f4087dbdbc02777e344ab6ad34b163"
    sha256 mojave:        "88c352966d876baf568c68ae19535425521810d3fbdb061a8a5bf72dca142130"
    sha256 x86_64_linux:  "0c52a887d546dc925ab2b818d097c85420f417ce46c5974312ccee480fcbf8ad"
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
