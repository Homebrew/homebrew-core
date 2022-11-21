class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.23.tar.gz"
  sha256 "ec982a9393b3217deecfbd3cf9a64109b85310a949e46a51cf2e07fba1071aeb"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "680da6a2a5b8473b5b42562ca5fa3f346657514485854ac7262149369c8d3f0d"
    sha256 arm64_monterey: "1d95ebb7bae0c0fcbd5ab8b276d8863baec7fbdab0fb886187af79cff48d4e5f"
    sha256 arm64_big_sur:  "f8a013aaa182322ce2bf5d28da57f2657b75e4f55bb5bd3666f17a6288d381e4"
    sha256 ventura:        "e6e17e8cdfc0a75768e90256ebd4b70e7badd8354bbfaedaa6aa1e8bfdaec152"
    sha256 monterey:       "d86e6c2df87f47d2b728a6e38549a3d9324b676a6790335b18ed47dc4f5aaa23"
    sha256 big_sur:        "d1185d44a56d4618278a608581dc483adc7916d0e16dcc7de1b675c5418975f4"
    sha256 catalina:       "e376e65455c75ee743eb49c703e2db8f79b92632cae8115fb55dbd5b4a5da878"
    sha256 x86_64_linux:   "c9a302bf39fdf2cd1ded64bf5076e3bfd19182bdd5808ae0e644cf6c1f7a54ea"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"
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
