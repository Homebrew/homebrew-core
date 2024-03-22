class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.3.280.0.tar.gz"
  sha256 "703c772a850fa7fbe57a2f8dc99b4c1422a59fa5ff098a80c8ce12fcdf6a2613"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a541638cb852ad2225a235289c581ff3181d5267812f02e2f52e711817257c31"
    sha256 cellar: :any,                 arm64_ventura:  "eb41db9ec007b0ba139715acfa4a4b2519c024443912b647b02dd74c619218f2"
    sha256 cellar: :any,                 arm64_monterey: "993e7eb16a68984c7d7fc8d58adfe3fced639d210fdc8ad8d5b4c51a32685db5"
    sha256 cellar: :any,                 sonoma:         "d701a67476e04254bddab96722966272a7f1ea0f5cf299bd87d66ccc7eae96c1"
    sha256 cellar: :any,                 ventura:        "51054d2b8835d88bcc7ae533e6ba00bab8a08d5c530f88d56f152b4c9e36f67a"
    sha256 cellar: :any,                 monterey:       "8a3eb7cb0ca82c62c2ea955f98fd6050b11007551ec415853df1e301048bbb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bac0ada508921fa89ee0ab37298dbd477118f016f6999adb695a5402ebe4b34c"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "04db24d69163114dacc43097a724aaab7165a5d2"
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
