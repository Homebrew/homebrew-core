class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.53/yosys.tar.gz"
  sha256 "126e93d82ceca9ece1cf973b395b46a1cc8105651a8ecf3de9afbe786cdeea58"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "b73197d7f42cdcd1fbee367d6f7fd3a155c8ad5d04bce3943a94eeaea107eee1"
    sha256 arm64_sonoma:  "ce9e23d578942c0500492fce049d759d58b326cfe65e2459814d08189d77f781"
    sha256 arm64_ventura: "0dad0c6a7aef5ad9ccc7f77e90d2de12bf5cb7e95602f36df4e1aa6191deff5c"
    sha256 sonoma:        "f5b6cc4c7f020672c173cb00a0ebd7ce630856d4545213da77f7872cdf37315f"
    sha256 ventura:       "fba2dfced224f204b7ca1adce942333c9bef7e293de1a93fa6f2917952a0eb53"
    sha256 arm64_linux:   "b12298d0378ed7a6864051582c095f3e0ae0113afe179cc483d364a034502b67"
    sha256 x86_64_linux:  "bb83f2fb27033d91a3140385090942b1894d2cdb3522dc638c928300cb6f6374"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtommath"
  end

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
