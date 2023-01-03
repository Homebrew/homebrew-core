class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.25.tar.gz"
  sha256 "673e87eecb68fd5e889ac94b93dc9ae070f1a27d94dacbd738212cf09f39578c"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "24941fa7064b467a9299e97397958a12e5a685f94da55444ad8913eb3caa5bdf"
    sha256 arm64_monterey: "234ee4cd1c3d8fa96184541c93c9551fe75adfb6c35f7a19317c42479f41d435"
    sha256 arm64_big_sur:  "e0a30205128f9a042552cf6ddfc24b956eb35c348fed7f735028d2294a8f9409"
    sha256 ventura:        "543faae5ddd5b1656f0ad5ab049f0827d3032e523cee5659efdea644422d6e0e"
    sha256 monterey:       "6f2168586964081142d68b02a6ea146f1aa26dc25a7cbd32b2029a60fd0c9a5a"
    sha256 big_sur:        "f13952265bf41021e559820361364eba6baeeb61ccfbf253314b5a735a9979c5"
    sha256 x86_64_linux:   "a49e6b4c45cb2d329d6835b64f3bfafc2bf7c3bd76b7714a09538343c234c8ba"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
