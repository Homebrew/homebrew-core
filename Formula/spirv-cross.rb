class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2020-05-19.tar.gz"
  version "2020-05-19"
  sha256 "6cf18ee3fe1a8d64a20da3c5fac334da4c4762d29d7e55a2f0b555cbf5cff708"

  bottle do
    cellar :any_skip_relocation
    sha256 "2397ede89356371b0ec7a36047bae6c3d2c1f2a8b51574ccf3d266cb3c30ba3a" => :catalina
    sha256 "8e9f201838957b0ee46dfc9aa2896c7ca467f1e37aa81d67d04f49ea9db2db0b" => :mojave
    sha256 "0a5ba5981e3e5d224a0e4ed710a163d436a73017918f4c6945a1c66e4095c853" => :high_sierra
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
