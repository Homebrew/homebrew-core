class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.350.1.tar.gz"
  sha256 "6f7b9b9eed9a7aa485918466ea604b4edc7969d94e96c0c13ae266f4ec120f31"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d96316b5072f5285b677b3b5246d11a9b5b236afe648451b5922b4ee74b3a4ab"
    sha256 cellar: :any, arm64_sequoia: "85029c4e7328c9456e2936aff449e161ba8e050d50dc917dc7385005a204cd4d"
    sha256 cellar: :any, arm64_sonoma:  "cbbc25f3007abd0aad199a66fced676c00b71dbb78a78d27fd1c55dba55c75af"
    sha256 cellar: :any, tahoe:         "584baff1c5041e657664d95deba1c1cd9fbbc93a3edde6faf0b9ea656849122c"
    sha256 cellar: :any, sequoia:       "9c7cc4dd56a720f40ef7f934e7b5420e42c997716e6afa300244f0b019adfe9a"
    sha256 cellar: :any, sonoma:        "c202b607ec4d15d7e04e84113aefacb2b11c4636fcdc13c90286b63eb16aa335"
    sha256 cellar: :any, arm64_linux:   "cfb7b1ec70a7ad61f6844d2adab424c18681cd71a65b1ea042439a090253a048"
    sha256 cellar: :any, x86_64_linux:  "4697c1714521f3e5ed58f3665da97bdf5a7224839a44483a65ff99ec30ad8f8c"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers" => :build

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV-Headers_SOURCE_DIR=#{formula_opt_prefix("spirv-headers")}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples/main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
