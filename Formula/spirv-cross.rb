class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2019-07-26.tar.gz"
  version "2019-07-26"
  sha256 "d246172543aa246853103fa7acb06951c9e6ff286adae5e395b7da97d76cf900"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c6c804a827a71a89cd8eead16456587d11aa1edb092677d41c3617dc39c0e89" => :mojave
    sha256 "bfc2c2fe9824e5cb5c1ce96b7c19d1ebae85eecaef5cf1c414b485c450fe95b0" => :high_sierra
    sha256 "987d910eb4116a10e16c5c98aba8b3501d3749e5413e70ae67ee5c3ac271798d" => :sierra
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
