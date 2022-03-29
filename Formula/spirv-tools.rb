class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2022.1.tar.gz"
  sha256 "844c0f590a0ab9237cec947e27cfc75bd14f39a68fc3b37d8f1b9e1b21490a58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ffeeb83915c6ad55978bfb7ebd8423442ae93e4ed449e9eab438e6494602b7de"
    sha256 cellar: :any,                 arm64_big_sur:  "ae2c2e66cc6ab3b6fbd52473ec9b22618bdae11d1b91824015287f5174074a81"
    sha256 cellar: :any,                 monterey:       "99864fe56b7d8b7ab7c89ce5657404bab2b12e3c06ec8022a5a2d3d85d7c89c6"
    sha256 cellar: :any,                 big_sur:        "21a9e7876cfae49779f503dc29831a609290bcbb350a37cef01db66dd6983e39"
    sha256 cellar: :any,                 catalina:       "877145f635f567b800159607057ecf63ab50f32c21b073d6cf69e92be8ea943c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349dc462ee43b71d0cec01d0b2e98c487d6881facf8ff24eef32e4b10d53af21"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "611baecbcedc9cec1f46e38616b6d8880b676c03"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "ddf5e2bb92957dc8a12c5392f8495333d6844133"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "b42ba6d92faf6b4938e6f22ddd186dbdacc98d78"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
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
