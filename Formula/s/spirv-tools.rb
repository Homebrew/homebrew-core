class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.3.283.0.tar.gz"
  sha256 "5e2e5158bdd7442f9e01e13b5b33417b06cddff4965c9c19aab9763ab3603aae"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b84453e25998947f6254a07dfa53563614824c8a7fcc9a5389e5f74e86802195"
    sha256 cellar: :any,                 arm64_ventura:  "693bd3be307040ec1bca8e7ae514f22f48c58b92a36fa0e48cd33e830d49348b"
    sha256 cellar: :any,                 arm64_monterey: "9c7454ed91e8b01042901b8bb82a9c2f8c65da25b1e4f010841b3d283fc24de1"
    sha256 cellar: :any,                 sonoma:         "727916a46cf1c614f736ac5563f81918a93affac472a6610a0ad47b9c0a5458f"
    sha256 cellar: :any,                 ventura:        "ad2aefa0ea6627155f89bc0e3abdc0a11562f57f1d850afac51e2608fd1e4951"
    sha256 cellar: :any,                 monterey:       "5f10870d1c846e9c3025b4eeba23a2edcca20cefc8989bc8658240234eafeb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a410e3d3be9910b65f01e3f8370635a48b9600e787805755b0f26fbf1b3e59"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "4f7b471f1a66b6d06462cd4ba57628cc0cd087d7"
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
