class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2019-01-31.tar.gz"
  version "2019-01-31"
  sha256 "1876b044cd21942752492c99f12fcd7e69debb6a63c52277ae83303bd6437f59"

  depends_on "cmake" => :build
  depends_on "glm" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    # required for tests
    prefix.install "samples"
    prefix.install "include"
  end

  test do
    cp_r "#{prefix}/samples/cpp", testpath.to_s
    cd "cpp"
    inreplace "Makefile", "-I../../include", "-I#{include}/include"
    inreplace "Makefile", "../../spirv-cross", "spirv-cross"

    system "make"
  end
end
