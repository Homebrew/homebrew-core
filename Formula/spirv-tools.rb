class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2023.1.tar.gz"
  sha256 "f3d8245aeb89f098c01dddaa566f9c0f2aab4a3d62a9020afaeb676b5e7e64d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "424baca5a4a59179022b98dc0d40d34f11d62c667608fb0088e01acc93629575"
    sha256 cellar: :any,                 arm64_monterey: "37ff0adf025355db66b40860640ff5e6d4425216b3c9a2ab8a9b723dda186baa"
    sha256 cellar: :any,                 arm64_big_sur:  "586a347e6d52a8b01469ccd62cd24a9d2d532434158a9abad9153ed46315e655"
    sha256 cellar: :any,                 ventura:        "1c9bf861005619c941fbd3dcf7b0feaf70a74ba052242e84bbcf92be551e7a46"
    sha256 cellar: :any,                 monterey:       "331935c85bd03884539fc5934bddc339eae754278000f0a1b3baf7fce3e3ca32"
    sha256 cellar: :any,                 big_sur:        "21469d8e150959f22fc1e826ad7dbb32ccf1594f622e73b157053f4ff6496cb2"
    sha256 cellar: :any,                 catalina:       "639ffc0722c8dc1359a04fe46ca8a069b015aed20707dfae199185737c749e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8d3fbc59d3e6f92e9b6a799ba7b93bac5c844eba1a16f5a1ebceb20f85f0c5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "954656f47fe8fb505d4818da1e128417a79ea500"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "c7b4db79f340f7a9981e8a484f6d5785e24242d1"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "d13b52222c39a7e9a401b44646f0ca3a640fbd47"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_INSTALL_RPATH=#{rpath}",
                            "-DBUILD_SHARED_LIBS=ON",
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DSPIRV_TOOLS_BUILD_STATIC=OFF"
      system "make", "install"
    end

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
