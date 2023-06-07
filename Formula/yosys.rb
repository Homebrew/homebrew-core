class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.30.tar.gz"
  sha256 "1b29c9ed3d396046b67c48f0900a5f2156c6136f2e0651671d05ee26369f147d"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "9b1be4e73387d838ed6e86227463c9f3a238fca60d247389cdc0bc3027a7a489"
    sha256 arm64_monterey: "bcb2d75dd08d529c2f79574127e27e9d6e1eb8535d1c2fd4eff3fe95b9003295"
    sha256 arm64_big_sur:  "8a93c954fab7025773e187196218019b909722d3cbcd5c1c82f946c0dfeed124"
    sha256 ventura:        "a5cdc4f4e5ae20bad5d1daa8146b9a76999fda8e26d78025f093c59c523f2ded"
    sha256 monterey:       "87713cdcb9e5379cac8b7b9f1f97fdc90ba65aa339a92647e18dc6fa2d9049dd"
    sha256 big_sur:        "14cbb9fb57578f2457ef3c9a7cd013c457a2129fd245dadd62b77be3483f5dca"
    sha256 x86_64_linux:   "c61e53dbb6952c1c67f44498c46b7bb268bb85e1e9af64c31b4a399fe04268d2"
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
