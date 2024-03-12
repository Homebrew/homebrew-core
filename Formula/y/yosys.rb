class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.39.tar.gz"
  sha256 "a66d95747b21d03e5b9c274d3f7cb0f7dd99610891dd66920bfaee25bc30dad1"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "841482c6a27aa30ee2b1f14f4b0748a91e9f36f2a3e89462b8bdbc7960e47fe7"
    sha256 arm64_ventura:  "490fb3491428ee1f4cb70c53789864ce937b7206909f46e440be611583c68a9b"
    sha256 arm64_monterey: "d29c2a6d10dcdbc2b3b19ef0ad3257634e68bb0a6ca76d40adaeecd4cbb1ed95"
    sha256 sonoma:         "6a2841b4ea0b9b12b6959cbaa41b6986d0869be25ede6316ccb906c42bb156a4"
    sha256 ventura:        "97d2ce8c071864511d3d7fd65717555eee97642f3773c2c43cd7a3d9d7938528"
    sha256 monterey:       "280eeea30d774610d3a961d87fd0c9c674b0793cafc03edebe9b66014c634e8a"
    sha256 x86_64_linux:   "72bbfbb4818634cd98b3f0d8ab2fa404e3e76c4f60293aaca5a4e2bd1683cef0"
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
