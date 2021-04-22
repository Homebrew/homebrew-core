class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2021.1.tar.gz"
  sha256 "bd42f6d766ac50f1a1ab46ce96d59e24ab28fb9779a71fccfa8bad760842c274"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f12ae92b52b9ea8020a5fe07ba44f3e4b465cacd71f23db04340a369f65c7f41"
    sha256 cellar: :any, big_sur:       "d08bd6ce7194e2d2150a50319133c818b5525b22b78da8530e3a125c34602c29"
    sha256 cellar: :any, catalina:      "485707bcd26aa53c8b92e3e2f885f0557dc0147eb114af89db8d1340b261b4bf"
    sha256 cellar: :any, mojave:        "51d1671e0e01d9fa4601c5b153ccc0e372676fb444d19f7d57b51130868eb5d7"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "f8e389f3acdc2517562924239e2a188037393683"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "2ec8f8738118cc483b67c04a759fee53496c5659"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "bcf55210f13a4fa3c3d0963b509ff1070e434c79"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_SHARED_LIBS=ON",
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                            "-DEFFCEE_BUILD_TESTING=OFF"
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

    args = "-lc++"

    on_linux do
      args = ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
