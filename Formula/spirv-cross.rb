class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2019-06-21.tar.gz"
  version "2019-06-21"
  sha256 "ce5024c48f2331ea9335204ed8e0e11ac3d6bda248b9fc1717385d8126ff36d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a8cdda3995d374fa85583a5f7518386540ab17dede8ad1f3b8c31706265aacd" => :mojave
    sha256 "af89f0c8336d550d11a61c3e4b97765367fc2705054ac4680936d0116e502fd1" => :high_sierra
    sha256 "106612c2a7a27f11644963b660aad68cc5bfd72f65e5bb9d4b452a0ced7afab1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    # required for tests
    prefix.install "samples"
    (include/"spirv_cross").install Dir["include/spirv_cross/*"]
  end

  test do
    cp_r Dir[prefix/"samples/cpp/*"], testpath
    inreplace "Makefile", "-I../../include", "-I#{include}"
    inreplace "Makefile", "../../spirv-cross", "spirv-cross"

    system "make"
  end
end
