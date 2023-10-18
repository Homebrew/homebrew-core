class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.34.tar.gz"
  sha256 "57897bc3fe5fdc940e9f3f3ae03b84f5f8e9149b6f26d3699f7ecb9f31a41ae0"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "ae5c6a6569ed651c60c8d39fecbd6f87535bdec397fa7883ec3f54326f85a1b2"
    sha256 arm64_ventura:  "5c0f1f469ee7060608fff395c485d30971f81e478f6736bf2c6e520bf349fcae"
    sha256 arm64_monterey: "5ff765a5a5fa35d66f46a4a75a708d8ed087c4d9d1e7bede6565ce8ce07bf1c3"
    sha256 sonoma:         "e99435951d0fc65133ac237cbaa122ca19d4f890d5948b4d201ae8dec7e5fba9"
    sha256 ventura:        "d947c530b8e6a556f8b10a2c36a90d30fc62e1db7b3aa9b8b7938b571a54915a"
    sha256 monterey:       "83acf34c15d2906d8acc79a14b9c8de24c209799cef4693accd944b18562a639"
    sha256 x86_64_linux:   "34c5f194e5024b48e68819b16acfa69c2791fce96a0542fbc842a4fede2c8c87"
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
