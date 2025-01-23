class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.304.0.tar.gz"
  sha256 "ad6e8922538c498e7131bcd82a8d6d9f9863b8d7431c5bfa27dd98e26435be07"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36d7465828c3835c3ab957726a85b1f79e7e876d26fac5a66032e4c3cc6697ad"
    sha256 cellar: :any,                 arm64_sonoma:  "c9804b1806f7c0b5a09f7d62f462429ee09d5b1219bf2da56d6ae7c26b438252"
    sha256 cellar: :any,                 arm64_ventura: "a817b536d023e78af94f9a82f72e9f1ec41dcccda23f620cc720446181a2fe10"
    sha256 cellar: :any,                 sonoma:        "46409fde53dd1dc9a6905c38f10fe99d02ef0fe4f549accc293811a1ce90a519"
    sha256 cellar: :any,                 ventura:       "5c2c4f586b3b13dbbc56d194e8cd62790306d78ac943cde34e80d4d301716160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efff53f539568f70854f458fa5578d211322e987d8fcb5a04741ab3abbf2909d"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "3f17b2af6784bfa2c5aa5dbb8e0e74a607dd8b3b"
  end

  def install
    (buildpath/"external/spirv-headers").install resource("spirv-headers")

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

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
