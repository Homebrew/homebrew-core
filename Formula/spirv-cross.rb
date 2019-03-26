class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2019-03-22.tar.gz"
  version "2019-03-22"
  sha256 "fe1b7e264463b973697082d124becf2eb98c78f6c2c119ec18b6f3b5f3d07044"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6ad044641c877f3ea71fea105efffa962e0fbbc08bcaba727f9981fc8f0f04f" => :mojave
    sha256 "ba72585aceb2f14ab986b8706ede32793aacbe6892ef7de92fe860152fcb868f" => :high_sierra
    sha256 "d01225d532e3f12e071581c82d05b59e80d29cb7a3e35a135bdfc7637a01dad2" => :sierra
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
