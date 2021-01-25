class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2021-01-15.tar.gz"
  version "2021-01-15"
  sha256 "d700863b548cbc7f27a678cee305f561669a126eb2cc11d36a7023dfc462b9c4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "224f4a1ac8dbc055a8ea1a431a82e275a3de850f805d7aa5388d05696616e403" => :big_sur
    sha256 "80a4ee152f875a3b653457ee40e0a05fa9892cc6203fd3d525e16157e646c3c0" => :arm64_big_sur
    sha256 "612183441f7920e7f6a3f4d87181e30ecc071a3d2d20185c8b3d614dc2deb30b" => :catalina
    sha256 "df9e5893b35edc958ae73b9e763ff63e35d5e8438f9e67cc332ec14ce00f6def" => :mojave
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
