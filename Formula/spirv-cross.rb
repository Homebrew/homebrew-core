class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2019-05-20.tar.gz"
  version "2019-05-20"
  sha256 "bc01afeacd77ff786a10755117a7aeb219c8d50e3db3931e59bf8f50f4cad55d"

  bottle do
    cellar :any_skip_relocation
    sha256 "12e03be1f9623a697b415e345f730be85d3139cc688feb2bd99fb7c6bd0b54be" => :mojave
    sha256 "198d10b740fc429b5066a9dd6a4bbc434743b644d7da36056e8b0f38667a487c" => :high_sierra
    sha256 "dbb73c590b196e097e38c843ad2764ebad59e34f5670ff50858f77531aaf5a92" => :sierra
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
