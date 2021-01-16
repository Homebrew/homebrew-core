class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2021-01-15.tar.gz"
  version "2021-01-15"
  sha256 "d700863b548cbc7f27a678cee305f561669a126eb2cc11d36a7023dfc462b9c4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "795b80c4182097a74736610ca4f5ef7db326f7c3fa1877034294c596e3eb6b5a" => :big_sur
    sha256 "eb5de887e646421b4f71ac84d34385acb9c060f8f7b6dee36a94a42a24c82431" => :arm64_big_sur
    sha256 "6c7ebf3dcc65a7392247b7643f6f36461720ef8399c52bd05aaf79ed53af2123" => :catalina
    sha256 "4da93b781991248cd8af56b41b84dc09a18f587a41e5a52b1f65f75a0be78afb" => :mojave
    sha256 "971cd943944647d47c1a6def86faed5f011236915d4085a7b8b5317610f32be4" => :high_sierra
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
