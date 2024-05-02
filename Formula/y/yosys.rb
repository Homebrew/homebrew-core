class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.40.tar.gz"
  sha256 "c1d42ad90d587b587210b40cf3c5584e41e20f656e8630c33b6583322e8b764e"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "75d7ee8f17f7dc158fe1a1bd8c1c9fd280fb09ab0a25a143c201c21a8ac81bb5"
    sha256 arm64_ventura:  "896483c8fa43db062a5157c3d36b1f86ac1876a16bd09a2ac50bc8d003a4f697"
    sha256 arm64_monterey: "9b54bbd852a01361bf35db9a96642788df222213537e6c08a5f572fa0fb876ae"
    sha256 sonoma:         "c43b4b8df61d3e5c4fe09b1a70083fb9029762a5e8211fe18c4c962c01098f60"
    sha256 ventura:        "04c2a6f506ec7803ead9d14362f3582cd39843252ff6e79e9b956791456f7600"
    sha256 monterey:       "c90f77e6c4265cee41becf2adf1948dbb17ca5e2f12fd3c78627897a3ae2b58d"
    sha256 x86_64_linux:   "f6bd5aed4e844557e246a8c5d10ee8762b8d98f7c1190c7dfa6b3703d96cdfee"
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
