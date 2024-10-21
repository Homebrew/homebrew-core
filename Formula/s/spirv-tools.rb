class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.3.296.0.tar.gz"
  sha256 "75aafdf7e731b4b6bfb36a590ddfbb38ebc605d80487f38254da24fe0cb95837"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1eb7ecbb0874326bf77ade45b32af7784e1534806e13beb465f410f18d4c054"
    sha256 cellar: :any,                 arm64_sonoma:  "7e589216dd90a65ec950b78fd6a059c48a6036ec92e6d0f284e6957b87b5da8f"
    sha256 cellar: :any,                 arm64_ventura: "024ed8087234902cee4875f4e9655a23b42802c2f5c761d400be18fa3506dd8b"
    sha256 cellar: :any,                 sonoma:        "61eab8b84f8d42ab55fe184cb06ed93955d80c5cee9bbb82b101aebf550956bf"
    sha256 cellar: :any,                 ventura:       "5eddb8840375d643d90e17bc96e6679d8ec852a36638acb2a38cf70dd28e0e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4a1e2d759c153dc74c250c65028fc7eb4393c52353e66faf64a1439a3ac40b"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "2a9b6f951c7d6b04b6c21fe1bf3f475b68b84801"
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
