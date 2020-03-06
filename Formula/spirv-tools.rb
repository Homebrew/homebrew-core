class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2020.1.tar.gz"
  sha256 "1eaa5e09c638d7113b60d825e6ce44406b35031be68db894a016b5faf45de568"

  bottle do
    cellar :any
    sha256 "31efbec043164a1f6105eccaf2031bf5482abac4567fbf6880e373a90ff3abd9" => :catalina
    sha256 "46438f2839f8258cec5593a0db9899c5dd7d9ae4c791ed0f349d6a5ab9164d10" => :mojave
    sha256 "741ef8b7a9b09ebc6cb485b6d752f5e2ea8e84643ca07aa8d2931861501f69b4" => :high_sierra
    sha256 "d2a4328e6a8e8e98114c97f547e87b248384855c9013d3b48c70a20b7d525a84" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

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
        :revision => "dc77030acc9c6fe7ca21fff54c5a9d7b532d7da6"
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
    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", "-lc++"
    system "./test"
  end
end
