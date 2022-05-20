class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.17.tar.gz"
  sha256 "37db450d08884a7c411f44ddf639284967ed1a39e11cd6b78d816186113d0173"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "2b41a59a19b8ffa228f2fee297b2b38d4272e3ed0303b609605b17647fdcd673"
    sha256 arm64_big_sur:  "c17710e4b39cbe2b674bf883fff99ac5ebc2545cbe4c943628369bcf0ea15f64"
    sha256 monterey:       "bcbe0977f44d1464884bfc1b18149373b12985762b09cf475812d146c7286854"
    sha256 big_sur:        "80320b77275467b1b8d57ddd03f251c2bdf2da06ca70fe77e87f272020f8ebf7"
    sha256 catalina:       "e9c5003d4eb68e1528ef96d301dd2d55b9aa7802ef5de3d038476840415f5811"
    sha256 x86_64_linux:   "422405c12f2ebfb94b4f6db7fb4c7d30a2e689c52379d0ae2c6989ed8888639f"
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
