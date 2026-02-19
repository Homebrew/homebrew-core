class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.62/yosys.tar.gz"
  sha256 "731c5c6f717b988153d0149f4c98059bd96e3bbca9704f52646ab7da97ea42aa"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9c953538b088eb90322b5b71fb12b02d03f892d361fe661e0e673974f84fddde"
    sha256 arm64_sequoia: "a9a5085d79e9720e23bfccfbd27f5391bd4cdf55e50b5c193e37230e3a8dc9af"
    sha256 arm64_sonoma:  "a19079c500f3718df1c3e5f310d2869f419de5ef2fe7c7ddd359782bea9dd259"
    sha256 sonoma:        "a9e8c673275f34e1bf4effc870833fae52537f7b8193a790b4ba92c2d8aacf69"
    sha256 arm64_linux:   "3f43cd74fefea7acc8fbd2bfa4bbffff17e1699f5f82c18357c23a55740f97dc"
    sha256 x86_64_linux:  "0f098ef63b458cabb78f4963eb3feacda31cace6bcf287eb5df7baabc0819ea5"
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
