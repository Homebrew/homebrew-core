class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2022.1.tar.gz"
  sha256 "844c0f590a0ab9237cec947e27cfc75bd14f39a68fc3b37d8f1b9e1b21490a58"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "0614a813a7ce60d0058e49fc16efcd7b7cc42aa88cdf24125b6f4d911ca99d83"
    sha256 cellar: :any,                 arm64_big_sur:  "8295ab8e466b1fb4762e0ed3cf73c319959e09a59576d293eb96e74f7538bcf7"
    sha256 cellar: :any,                 monterey:       "9f839427e49ce5d0211249157289800927672ca7afeefa8d961649a4704d5052"
    sha256 cellar: :any,                 big_sur:        "3ee9a3f37165bab272d6a1f4c7d8f58648101974f24759fe5e5b30ada07b7a14"
    sha256 cellar: :any,                 catalina:       "8c19649797b273df39a4220d293a2c7afc9215e3a308e826f99c945c8f324d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a332b0f4241fe4805202f4e255088680ed5c0b84fc2379cf00f169e249a6eea7"
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

    args = "-lc++"

    on_linux do
      args = ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
