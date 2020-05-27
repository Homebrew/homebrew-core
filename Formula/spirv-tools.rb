class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2020.2.tar.gz"
  sha256 "29f376f6ebc24d3ce39c1aa47101c4b5d256c8247e41068b541dd43bb88d4174"

  bottle do
    cellar :any
    sha256 "50167a8fc8d8f9997433498d764cbc7186acd3fa52451501c1de2b5a92ed9ab3" => :catalina
    sha256 "0cbe026c0b8ed983431d7cc6998a4f1c922413b7f86adafc0110827cde973ed9" => :mojave
    sha256 "9d4211c03f0c59801d4f905a667546ab584d3e4c14d8d5942921e5fb75d2e886" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        :revision => "5bd613749fd530b576b890283bfb6bc6ea6246cb"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        :revision => "cd25ec17e9382f99a895b9ef53ff3c277464d07d"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        :revision => "f8bf11a0253a32375c32cad92c841237b96696c0"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DEFFCEE_BUILD_TESTING=OFF"
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"
    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", "-lc++"
    system "./test"
  end
end
