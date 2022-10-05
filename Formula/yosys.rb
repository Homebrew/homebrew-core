class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.22.tar.gz"
  sha256 "2a0c29b6f66b3ee70316dd734eceb14f452445a83ccac600b97100ffd7c7a7aa"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "1c1e6673901892635667fcc963360c10056725610ca233d4b602bddd37bc5e0d"
    sha256 arm64_big_sur:  "f0300172aa17a205c68f85d2021837ce6272aeecef42ba6d0ca9dae1b4d48ea4"
    sha256 monterey:       "109917211dcc66a0e2e082c22732b0f2ba01f0c4cc718c2db36f5dccae82bc41"
    sha256 big_sur:        "a78be329b5ca7583df2756f6835774a49f97e36420a845062dbd7c0756b79241"
    sha256 catalina:       "0feb23a7b7911ddd4f156e5ccaea24a736fb1ef44ab760c7cadb248a35a9c8b3"
    sha256 x86_64_linux:   "0086578f4bbf3816e988ad82f17fe6f083cf0d0c9e6d997404bee94b0d172d12"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"
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
