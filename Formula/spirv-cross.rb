class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2020-09-17.tar.gz"
  version "2020-09-17"
  sha256 "a3351742fe1fae9a15e91abbfb5314d96f5f77927ed07f55124d6df830ac97a7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
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
