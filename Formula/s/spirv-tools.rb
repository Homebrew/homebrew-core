class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.313.0.tar.gz"
  sha256 "6b60f723345ceed5291cceebbcfacf7fea9361a69332261fa08ae57e2a562005"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "526f0b2be7bbd832d10573e1504944562ca8bd0ab19ac5c6fc5fcfdf0192ed65"
    sha256 cellar: :any,                 arm64_sonoma:  "0d90a066a6f63a137cac4c38c8fe51f76a00f9ef2dfc00b92c06fc2aa11c1fa1"
    sha256 cellar: :any,                 arm64_ventura: "1d294b9fc1c423c9ad997ae94e25c7190a4e82a465cd3031ae282973619284b1"
    sha256 cellar: :any,                 sonoma:        "9794747ef0fd5434ba74f445d5af1198fec7b8214c7a793a904c414ead9862ab"
    sha256 cellar: :any,                 ventura:       "4617fd500944d9e90b85ddc05344e9ba8b74122b0a4b8eb73005de8f79ee6824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a04290d072ea9b93fd08f71a982aac88449c20b6ab226d574c6a4a33bd5e4a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3536edf22844dc6dfe7da464204f439302842544a8e5375497abd2a256c89d3"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "aa6cef192b8e693916eb713e7a9ccadf06062ceb"
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
