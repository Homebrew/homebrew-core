class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.25.tar.gz"
  sha256 "673e87eecb68fd5e889ac94b93dc9ae070f1a27d94dacbd738212cf09f39578c"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "5aa1a136f305bec4a615d1736b5a4ef29525f699bde225c1e910417742a08776"
    sha256 arm64_monterey: "a670b84179740106078a3f9b03c7507502e90fec395329b8de010c5ede65e970"
    sha256 arm64_big_sur:  "578eae4e30996cc1d4fb6d6d0b14ad591e5ea473cca276b97f3d8ae1e52fdd35"
    sha256 ventura:        "b3997d7447691848f565c354eb3015ffb6c7ec85d4331d47bee65cb06e039e0b"
    sha256 monterey:       "5efdba6e9a888c1595162e22ab947a02dadae0517d3cb439d343f5541a3e77ff"
    sha256 big_sur:        "a3281fdd5f456b0fdad89edacfdc1182f83f69bda5b257fd642791be3ecf20c4"
    sha256 x86_64_linux:   "b439cc7436847e45ba76af2d3b81da3d15ce5d06bc62f6ff701a56b7b5f84de9"
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
