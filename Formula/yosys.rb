class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.27.tar.gz"
  sha256 "bd6c933daf48c0929b4a9b3f75713d1f79c173be4bdb82fc5d2f5feb97f3668b"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "60e478f6eed317d3dd5f9c1123af6c376dbfa52d79d19b91b1134ad1fac6f72a"
    sha256 arm64_monterey: "962b63e35580c6363f83f7a0fea8ac21895a76bea04e931e96c79c1376601167"
    sha256 arm64_big_sur:  "8932d6d05e640356cba570a45761d3c02bcfb2488f1eb205f0de34efe85a91be"
    sha256 ventura:        "149e3c31a259575dbbc65bc29f35a6d3c930e5b35c6fb55cdb5288c7bdb35661"
    sha256 monterey:       "469ce8fc8e08174fe6c694f846506f3d937f67cea4d948ffba3375a45221f428"
    sha256 big_sur:        "22822fa52251408fd7e15fa7b08b73745fdb8065931a9eb48426c9c4c61c0d52"
    sha256 x86_64_linux:   "d2912ea3550962a24e8f0c551b9d2c16b2ee3ab0de408b98007ef650fb84e439"
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
