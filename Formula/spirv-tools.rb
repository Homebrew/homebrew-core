class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2019.2.tar.gz"
  sha256 "1fde9d2a0df920a401441cd77253fc7b3b9ab0578eabda8caaaceaa6c7638440"
  depends_on "cmake" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        :revision => "6cf8ccd82dbaab2668e9b13596c68183c9ecd13f"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        :revision => "04b624799f5a9dbaf3fa1dbed2ba9dce2fc8dcf2"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        :revision => "e74c389f81915d0a48d6df1af83c3862c5ad85ab"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", "-DEFFCEE_BUILD_TESTING=OFF", *std_cmake_args
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", testpath/"test.cpp"
    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", "-lc++"
    system "./test" # note the example is not work now, https://github.com/KhronosGroup/SPIRV-Tools/issues/2538
  end
end
