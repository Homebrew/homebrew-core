class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.70/yosys.tar.gz"
  sha256 "c6bd8b83aad633f6786fc861fe8f5dbc74c37bfae77f7bd0220e6f00f15f1d55"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "0a9129cf3998bc01f039a9e528adfde5619d56d6897f8101475d411ce4ef24bc"
    sha256 arm64_tahoe:       "b9ec40445192f41fba6b960a96cdda676f13adeadfc048f76d37228ecc416721"
    sha256 arm64_sequoia:     "970a7fecc485fed91cc4e73d6cf5e14216612a5e2ff69e3bad493e6ba55b732e"
    sha256 arm64_linux:       "60f98593edac707f5fb571073b9a4a4e0b4feaabc791d2153996adfb1ab764a6"
    sha256 x86_64_linux:      "04ec8b6981a6d8d05a217f2c3e7d30d3afb7af6e22ad06b43481080a085e58ff"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "fmt"
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "tomlplusplus"

  uses_from_macos "libffi"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Avoid shim reference
    inreplace ["cmake/YosysVersion.cmake", "cmake/YosysConfigScript.cmake"],
              "${CMAKE_CXX_COMPILER}", ENV.cxx

    args = %w[
      -DYOSYS_WITHOUT_EDITLINE=ON
      -DYOSYS_WITHOUT_SLANG=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
