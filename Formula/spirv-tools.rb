class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2020.3.tar.gz"
  sha256 "8b538a1cb2a4275ef9617abcb047d54e8292f975ac1d93323d5dd1e19c85280b"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "eb2e8acb244d040f0bbc586c037650a13672c32b5894fbe54be1531eb649ee35" => :catalina
    sha256 "5874ff4a3b024d83c6b203e75087717951b571352bf1a25a59aeb4e58e5194fc" => :mojave
    sha256 "f9f5ffdf2de7a2650b251aad002e94b27d16818172f2a168ca51cda8b80bf74a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "5bd613749fd530b576b890283bfb6bc6ea6246cb"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "cd25ec17e9382f99a895b9ef53ff3c277464d07d"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "f8bf11a0253a32375c32cad92c841237b96696c0"
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
