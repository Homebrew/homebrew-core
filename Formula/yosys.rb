class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.29.tar.gz"
  sha256 "475ba8cd06eec9050ebfd63a01e7a7c894d8f06c838b35459b7e29bbc89f4a22"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "2a87c254bd15c695a71ce11739508c3d0698a85b76b3382c1850f9c9751d7369"
    sha256 arm64_monterey: "d8e315649f41163accb4c0617c4a044f6ba51cb69df507f98f77e78198b191e9"
    sha256 arm64_big_sur:  "107970a050ded329f9caba26c6472116fe8bb41ac5e6dcd1ead1fc2fafde7c48"
    sha256 ventura:        "fc6bfbc4a2b301242a7e080872c1fed78e2e7c3dcf30fd02e08fee8d99b43c9a"
    sha256 monterey:       "70fa58f0a458e96b4c83777e030447b085a99b39e0e438fc4b95852717d12346"
    sha256 big_sur:        "519852a3268fcc6cbfb6880efe936779a3dcad45ebef1bad39aa20041a3d5577"
    sha256 x86_64_linux:   "6a92ad7749002dea14caffcfa8cbd0336c3464f419e1ab141d3829b67c3c9d38"
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
