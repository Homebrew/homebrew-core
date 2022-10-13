class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2022.4.tar.gz"
  sha256 "a156215a2d7c6c5b267933ed691877a9a66f07d75970da33ce9ad627a71389d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3676eb82afbaed373d6890f396c776894e203462236e54dc78c875752d49c1cd"
    sha256 cellar: :any,                 arm64_big_sur:  "bff478f3a0a4568b59a334ffa58ca36bf28fd2c231d7c45da751748dd959ba6a"
    sha256 cellar: :any,                 monterey:       "fdd9b70b3a5bb37bcf950d92fdf935858fbe28fddcfdeb26d6cffd6fa20ac384"
    sha256 cellar: :any,                 big_sur:        "2fd8180138dd9ce986b05a3c99949a1f93e74401c77861108164e0cc858d29c6"
    sha256 cellar: :any,                 catalina:       "cf5831027fb19732eb90e87581569d21bcf60041abfa0e275aac18f19d9b0cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a23cff43a7e33773b6eb205fe5be7a9b28c24863186f148633c5d42ffd4386c5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "d2836d1b1c34c4e330a85a1006201db474bf2c8a"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "35912e1b7778ec2ddcff7e7188177761539e59e0"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "85a1ed200d50660786c1a88d9166e871123cce39"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
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
