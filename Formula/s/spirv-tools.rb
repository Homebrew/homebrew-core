class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2023.2.tar.gz"
  sha256 "7416cc8a98a10c32bacc36a39930b0c5b2a484963df5d68f388ed7ffee1faad3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd86ec4dadaf9a5df724b5e8e2d0b3434e9dece5f1d0f693171e2b3b49614e31"
    sha256 cellar: :any,                 arm64_monterey: "0637ae77abc11f9ba1677119426ce011fb2e5f6580abcda1d6a6c44503127a69"
    sha256 cellar: :any,                 arm64_big_sur:  "ee408e7ebba7faf63f468dbc17addff81d36a1d056abdacb070c5cf542b178b3"
    sha256 cellar: :any,                 ventura:        "4bc22b444e909a223e10dd78a4769dc610f5d81bc115d3baf4f047c11af9b5c6"
    sha256 cellar: :any,                 monterey:       "058ed9c4f4104887ae3a57458ee1d4e5b13f82b7303f114b4db5920aa25389d8"
    sha256 cellar: :any,                 big_sur:        "b212c0450234482cbf842614c8c8c82cbc2fa00eb6e4f63aae88aeeb47e05841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0f52bb57518a8cd11a581164b724b2585c0b63753aabe2263027c1ab1bde5c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "b059ae85c83ca6b1f29dba20e92e4acb85cb5b29"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "66edefd2bb641de8a2f46b476de21f227fc03a28"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "1feaf4414eb2b353764d01d88f8aa4bcc67b60db"
  end

  def install
    resources.each do |res|
      (buildpath/"external"/res.name).install res
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_INSTALL_RPATH=#{rpath}",
                            "-DBUILD_SHARED_LIBS=ON",
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DSPIRV_TOOLS_BUILD_STATIC=OFF"
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
