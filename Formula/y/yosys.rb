class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.59.1/yosys.tar.gz"
  sha256 "5d442ed3b8ba90147be3939953f5104f019b46dfee6472a904d46b7143fcec1a"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "619ce24808198c8540c67187b2a1798832453623fbe532ac62c2da73b7a0553b"
    sha256 arm64_sequoia: "3eb5d4ea201f256c367594b3010284b65aa39e14eb5af4223ba9e536c66725ec"
    sha256 arm64_sonoma:  "699c07057f6e37e6a605030f88a8f5e7b4ffe68354ec35e7cb19ecfb1ea44f64"
    sha256 sonoma:        "6a6d82b18c555279fa28dad56fa3c7ed5f8e43d9e231ea0863706ccb805b3491"
    sha256 arm64_linux:   "d66c8aa3523e1c76da12d3007a71863b72b6dadde512e7741cbc7ee9ab9c31eb"
    sha256 x86_64_linux:  "31369711bb1660d2608bc6886284f5864a424d17def69c5a53ca88e41a19c047"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi"
  uses_from_macos "python"
  uses_from_macos "zlib"

  def install
    ENV.append "LINKFLAGS", "-L#{Formula["readline"].opt_lib}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
