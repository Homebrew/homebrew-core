class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.321.0.tar.gz"
  sha256 "8327fb8f3e9472346a004c91dbb83a6e5f3b36c3846c142cf8c0dc8fac8710f3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a773817b52358ad902ecd590f9f8321461ba42bcebf6ba3c7a00fc4606f87c1"
    sha256 cellar: :any,                 arm64_sequoia: "ebb1c57e0f9cfd77dcf9e9a11c09f3775274251b928b0629719f1f7bb51afa5a"
    sha256 cellar: :any,                 arm64_sonoma:  "1d590b32bf48250371181e59c1ce0168c66d33006f5dbd88198b7fdf7da39353"
    sha256 cellar: :any,                 arm64_ventura: "48ff490ce54dcc9013f8ba3aa3c4e56098436b53843f51b9f2d85c72f68e9649"
    sha256 cellar: :any,                 sonoma:        "ef247905d7a6296948ff6bd1342f4033efa5c5bc6ee85dd4535bf86001e04ad3"
    sha256 cellar: :any,                 ventura:       "e4ab64e171c4b429d3ed2e7fa487a31eae1a15f241dae4e422ebaba3b931ef20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e0642587aea3cf5cf46be903d701fde22809b02d7277ffd5dda8980c0ff01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcb5b2b95375978d14f1b470343c4e1c00d159d940a876d356a3fa50e83bb005"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "2a611a970fdbc41ac2e3e328802aed9985352dca"
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
