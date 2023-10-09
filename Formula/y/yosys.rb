class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.34.tar.gz"
  sha256 "57897bc3fe5fdc940e9f3f3ae03b84f5f8e9149b6f26d3699f7ecb9f31a41ae0"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "85be5d7db2978353a095eb8260ef7512bc1483e1c359e0b7f1ed0a143badb98d"
    sha256 arm64_ventura:  "703e3a9d2ec6cfdfb6d3bd5ee102d56471154c104bb2a5d0f0aff1fa22cccaf1"
    sha256 arm64_monterey: "f936e3011a6cc48b498b3d3a62101731829f995a2722a076bca2c833af0a3c11"
    sha256 sonoma:         "9ce7bcc3dd336ab1e5ca55d1d11b8d215fdb6046a2eaf6d2a767f95c816803a8"
    sha256 ventura:        "5a2f783327df7e20354c65ca02ef414ff64addbd88f6fcd603c0c90cecd0b07b"
    sha256 monterey:       "3f0f9eb824b3327c05ae37058f1e33302f42da7280abea6e9b45878e2e5c9f58"
    sha256 x86_64_linux:   "5398d12b425c0cd50f4f4883cec149594110f5a575ac9e6402dc0b8e542c3a2c"
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
