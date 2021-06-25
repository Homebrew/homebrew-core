class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2021.2.tar.gz"
  sha256 "2416a0354a0b14b8e7b671f6f99652cc8a8a83dc9acf195dafd22fbee5e92035"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6447d0c3e27b513115ef279846482de3eab7b7ab849d3e290fa6bf485763d790"
    sha256 cellar: :any, big_sur:       "cf912a525b1c8191820d6f3d66f41c9a9b247c2b1f0ee3b515b4564b6d7b4a28"
    sha256 cellar: :any, catalina:      "759cddd516c629938b4f45af5e285e9f3c4fe9bc602683a2503b5e79535333ae"
    sha256 cellar: :any, mojave:        "2856a927e0af7af8e15c5f6a6402c7c91ea0bba0ee404f184ba26f43f9dcf68b"
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
        revision: "07f259e68af3a540038fa32df522554e74f53ed5"
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
