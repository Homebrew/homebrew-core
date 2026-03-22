class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.63/yosys.tar.gz"
  sha256 "ab1cca30e9c45ebcdae240823aeaf7139b22f86b6046644807e074b7da5466b9"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "664bf46c55500f3859312de86f119d494caf53be145d03df312a63a0bdc95166"
    sha256 arm64_sequoia: "a0e9be3d859a0ba6e04206e7f285d80644995e5de7c2b5c06f0a9a70b3254d81"
    sha256 arm64_sonoma:  "ba1d73d323b1e8745d810ee5bac5d63649d0aecc1209ffde3fd33f94ce06fe38"
    sha256 sonoma:        "547ca79f85722c89d42236ac39660401fd36e5db5361952a9b268fdbbb1ab677"
    sha256 arm64_linux:   "c41e811729ea911431712e51a62b8fcd78a1a922f6f680575d77ad5947665784"
    sha256 x86_64_linux:  "88bd589f2515390139f8bbda0bb0840532d92aa6f700b0cb132e610e10e58ffc"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
