class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2022.2.tar.gz"
  sha256 "909fc7e68049dca611ca2d57828883a86f503b0353ff78bc594eddc65eb882b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "73eedf8672bb4660413af6790faf4ecfcab17d8b8fde2ecef260fda42fa3cff3"
    sha256 cellar: :any,                 arm64_big_sur:  "819165a5ff7d8815bd18b1fcf8c15533399d4686772b676f19687763dff8237f"
    sha256 cellar: :any,                 monterey:       "bd3b1cdb5f1affa95854149d5747d2633049812fab57c715cd811ebcbff45c92"
    sha256 cellar: :any,                 big_sur:        "2758dddd127ece04c24b971fb35f82db495c1c87500e3deecbd471df3d1dd9aa"
    sha256 cellar: :any,                 catalina:       "872b21f30c08220149a9ac2da611902a6e033f47e74487495a39d45df3dc9661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77696fd69bce9603fdb397e4968682c68943a291d50642aaf8a7c7ffd8bb8a01"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "0c5616df9c0aaa44c9440d87422012423d91c7d1"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "ddf5e2bb92957dc8a12c5392f8495333d6844133"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "4995a2f2723c401eb0ea3e10c81298906bf1422b"
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
