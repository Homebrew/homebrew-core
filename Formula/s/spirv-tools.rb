class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.309.0.tar.gz"
  sha256 "6b8577054c575573ead3ad71cb6a2c0b3397b64c746cc3c99e48cc5e324c1b55"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f5f2e1ba96aecba35eae1799552f436b222d077c6ac112c4ab9c491f51bda4d"
    sha256 cellar: :any,                 arm64_sonoma:  "e80491c515fdf0656fb5c31557accc6565897f50a55354129093a71d8a34e63f"
    sha256 cellar: :any,                 arm64_ventura: "9bba6a4515cb43ae13bc4ebff4bfe2c8bb6fe5b28df55aa7d05a21f6160ad6be"
    sha256 cellar: :any,                 sonoma:        "7154e89ba9cb1f3563278fd15275871aa544ad8604ceb423939fca7a0d2f88b1"
    sha256 cellar: :any,                 ventura:       "36bbd5099b5a79720e187a4fd58eb7da8ce7bd3a3627cff0ce2642dbcccb822f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88e79536d3037ce4e565d7b67f7dc98deb3bedb69f6ce58796b7fafc6ea1231e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6d416dacf98bd3c2422672d6ab8fbc8b0abfcc38a5d6b5521bc72cb0a86fbd"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "54a521dd130ae1b2f38fef79b09515702d135bdd"
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
