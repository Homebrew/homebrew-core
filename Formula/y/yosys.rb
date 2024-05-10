class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.41.tar.gz"
  sha256 "b0037d0a5864550a07a72ba81346e52a7d5f76b3027ef1d7c71b975d2c8bd2b2"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "27f2093f6a86d0e6878744e355528d2a0cfa8e2455d1d8848540dd656a197ef8"
    sha256 arm64_ventura:  "de80acad23e2a5aa03183d4ef9d5d996c618ee7e9ee0447b867f33b462fa19ea"
    sha256 arm64_monterey: "f71ea7807d0273d39b0f893d87e2682412a3f72d9fd33836dc401ab204e4c7b8"
    sha256 sonoma:         "5d76d6f89bcc86f2f90e7379657c55812966126c9b0c6bfb785fd8be0319b929"
    sha256 ventura:        "004aabb179927dbb01814048bbebf2ea3456e6b95b0511fa797c34b40902d39f"
    sha256 monterey:       "3971c23a8419b9b70e105568aafb930295c2910002e37f2277086e79a0bb8313"
    sha256 x86_64_linux:   "7a3335765fc4ee3d046bfe08c1fd949858d50e5649bfcc9558072938a47fa8a5"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
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
