class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.71/yosys.tar.gz"
  sha256 "2ec7c2ee63bb9b4065d6d5fff2786a1455e834f90ede8eb1d47791153ebef2a5"
  license "ISC"
  compatibility_version 1
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "653a24453a8b9125c352ab55d14c1703b4210b1c2f29c94e7b871f7c06a2b07d"
    sha256 arm64_tahoe:       "4032409cfb47e6d0d6b35eeb19a16c3d010797923a7a206d1ef30dd5df289ca3"
    sha256 arm64_sequoia:     "033dd90b9d15446fdd177f848624309cd372e2f70862e45e7395274e7bccea66"
    sha256 arm64_linux:       "d2cce338a3f6787e14f2691108ef038625a9b3f9e21fb72d2a6f58dd830449bf"
    sha256 x86_64_linux:      "221ee545f384691d422c18e85ac7c740f4513359a0f2a1f65dd9905b50e9af41"
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
