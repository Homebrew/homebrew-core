class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.33.tar.gz"
  sha256 "c240fa4fcc71c73b8989ab500f7bfa3109436fa1d7ba8d7e1028af4c42688f29"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "d8ffdcc475659338a8d7a1aa323b4355f89a48fd5ec3e4db98b2ae9e92cfe661"
    sha256 arm64_monterey: "7edc4d7b782889e5d1a72d57979fc5579f051e297f35d9cefaab7dd8cd0ca7bf"
    sha256 arm64_big_sur:  "fab6f71cf030b5668b2386b9a1874d237606b3fd3dd7d975db4db94b6a7fbb04"
    sha256 ventura:        "efe7aae30e16f1ad2609051ebdc148b3a6d9b24c1ff4bfe79bb36c6789cbcea5"
    sha256 monterey:       "667277260c9a7e09af13186bd07e2d60229e84dc4f4444d992c6a0f4314c6d76"
    sha256 big_sur:        "b8efb5d78dded34a457feb2a25fea25a757b5454bba272f592730c1a79421faf"
    sha256 x86_64_linux:   "b637f68a4c7318c058038bbe2820079d2bda0e0ded788adcf9917ac0fff25b2f"
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
