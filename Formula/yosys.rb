class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.21.tar.gz"
  sha256 "2b0e140f47d682e1069b1ca53b1fd91cbb1c1546932bd5cb95566f59a673cd8d"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "ec8e2485f732e9235d346c6314b3c5891cefee2b4a3a1f14e9ad73e5a15aa52b"
    sha256 arm64_big_sur:  "ca1340356d1fc7f9cd8314c9b7dff694eda12a9ffdc7d019bd2441a37a2e4000"
    sha256 monterey:       "a46a642b3dad0836ac662209b9cf642674bb406fb981474e24c6c7263f603533"
    sha256 big_sur:        "edc025e0ee8c999ea5cb87d31f6bf0af1e79bfa1c632ff96ba2cd99b71762ee7"
    sha256 catalina:       "7f8b6ae653fc3e24bd7dcd181a4c4ceb6fec17140ce2b2d194d7d5e16e1348ab"
    sha256 x86_64_linux:   "b3f54b1b34ab3042e273182fcaebc3f1f63b9762bbaf9bc8bdecd29f125f3259"
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
