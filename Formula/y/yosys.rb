class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.39.tar.gz"
  sha256 "a66d95747b21d03e5b9c274d3f7cb0f7dd99610891dd66920bfaee25bc30dad1"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "b6e2be927cef62f7e8804abe1c64b22bac7d1f4aee64342c051192c813f53642"
    sha256 arm64_ventura:  "3f233294cc04572ec8944a3e8a9cb8b6b67121761a5ffb7b85180033dc0a7784"
    sha256 arm64_monterey: "416538eecc77dc816cf863cf03288965c3ee7710eafbb1fffb56eb32f6f0a8b4"
    sha256 sonoma:         "84dd5ddb467ca20535ef8034521efb55979939a49b3949cb3c250aa610d890d9"
    sha256 ventura:        "4163fc6973dec7917c2a1f7f8bfc56301efe6eba2e739d72b8555872aecd2a30"
    sha256 monterey:       "21d84a1467ef8c1bd989ef43abb21e636e7cd5f3460b7a6f92f394769623c94a"
    sha256 x86_64_linux:   "f06641eb20a2038be70a722a79cb1bfe6071a737a73b8fb3f2bbca988e8e4152"
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
