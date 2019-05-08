class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2019-03-22.tar.gz"
  version "2019-03-22"
  sha256 "fe1b7e264463b973697082d124becf2eb98c78f6c2c119ec18b6f3b5f3d07044"

  bottle do
    cellar :any_skip_relocation
    sha256 "835b415ea283c5c4d0ad0b619dbcadc5e96f47a537b71f1bc5003462994ad6fc" => :mojave
    sha256 "054e2e1c8092b4f0e84214272c3569903d04acd8eef76cfa06ad1bd3056914d8" => :high_sierra
    sha256 "d744590cfafe2528e02a40d2295eda06da5e4e7e058ce7973f3f88c0ec472d35" => :sierra
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
