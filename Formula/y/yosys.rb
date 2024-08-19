class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  # pull from git tag to get submodules
  url "https://github.com/YosysHQ/yosys.git",
      tag:      "yosys-0.44",
      revision: "80ba43d26264738c93900129dc0aab7fab36c53f"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "02a3f725c4605d69852f85f2b47d72254b475df34a06e40ce7fd48eb3fd414b4"
    sha256 arm64_ventura:  "2834a9cdb5e681792b9a89bc3cad24bbde8e48fc227cd12abd096d19c165af48"
    sha256 arm64_monterey: "28f013515d2711eab6cf9cd92cfcf4d6359e4bb3cb27a9b8e732f67019ab52d9"
    sha256 sonoma:         "f4224a3f256300f609aa3ffd9b279f1e4f23687cc2d0d8ff2c717a8f3364c07b"
    sha256 ventura:        "84f8dde8211fa63912d4f5623acf71b67a85fc80068422aa044478d4d7e0b2fe"
    sha256 monterey:       "a2e4311bc91fb531ae82611336cc28d10172e37ed4c9d7bda53019041cb01018"
    sha256 x86_64_linux:   "dc80df85d1a920d97411b806d496e6e2dcf39c8101844d895cfff8c364876ed4"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
