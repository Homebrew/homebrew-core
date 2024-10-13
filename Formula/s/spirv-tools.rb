class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.3.290.0.tar.gz"
  sha256 "8f8b487e20e062c3abfbc86c4541faf767588d167b395ec94f2a7f996ef40efe"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a2e4ca601b9d34e4f15192e73cb32bb0387079becde119582596da4676fb9942"
    sha256 cellar: :any,                 arm64_sonoma:   "e994ad4f6102615c0cb3cfc907aefd215267fb9f4e39dbf417bd1fc121145ac9"
    sha256 cellar: :any,                 arm64_ventura:  "92a33694a5a95c71bff174e91c37238da82562ed3ec9666b840ee6590b231b43"
    sha256 cellar: :any,                 arm64_monterey: "8aa3630927adec8f14d785954b5f037874a7fcd246bfdf597a2a3c69be2c9deb"
    sha256 cellar: :any,                 sonoma:         "a60accce9f871a519dacfa25700c2321f66e0fa1bea1b6fcad45fddc753a830b"
    sha256 cellar: :any,                 ventura:        "1ec9af572300ba8fad5214da338ba76d5271d37df79391a674b89185cdf3a75a"
    sha256 cellar: :any,                 monterey:       "6975abada624f5da3ff31ca7c3bf6254ae95298adb838109fb4f30be5ab081fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b22bb62ae2bc1f29c94de38bc81c978d88da41ffa6f09464688778fbab6d9672"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "2acb319af38d43be3ea76bfabf3998e5281d8d12"
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
