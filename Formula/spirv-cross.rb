class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2020-02-26.tar.gz"
  version "2020-02-26"
  sha256 "74303f619a61b9668976a64c77f5dbd024ba45fedaaf36e0c2569532eb7adb7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec18afeaae3ccb0cdb4494f23357c895f274d976e52f80101187f421a0cabf5c" => :catalina
    sha256 "8b2f15158f42c012a134801d069b388e6a12141db5c5bde156b2916278ac754f" => :mojave
    sha256 "c248d3015cb9b074e5924b9f0d675a2c0048c39d944901a72d621d1a375e179e" => :high_sierra
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
