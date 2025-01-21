class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.48/yosys.tar.gz"
  sha256 "6218549aaadbfa79d43b29dbd01caf4e6ddc37bbeadf148d91c3b79526fd6ba1"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "2a18c05df11d2c423d8caa1ffc496f8975b887027db3cf98a1864b490098561b"
    sha256 arm64_sonoma:  "39c2f57ecf6b151897330ca1d78ea14770e83ae56925b7a6a5fc4d2452c08604"
    sha256 arm64_ventura: "e88c145d08a9b38f86fdfb4bae86c096b2c427605e505bb641726f1c8c4acd16"
    sha256 sonoma:        "718a90f56d5c5221934ccb1dcd007d800279627aa3015c19d826bdf223128c32"
    sha256 ventura:       "c62b40829a932e172d6ef92729edb0c54308cafa3dea4b1b54673134886bf28c"
    sha256 x86_64_linux:  "6d18fbb810e197f5a0c4399c44b590187c9e884cbe3810603e561a082ccf2c03"
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
