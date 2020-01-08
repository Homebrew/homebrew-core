class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2019.2.tar.gz"
  sha256 "1fde9d2a0df920a401441cd77253fc7b3b9ab0578eabda8caaaceaa6c7638440"

  bottle do
    cellar :any
    sha256 "31efbec043164a1f6105eccaf2031bf5482abac4567fbf6880e373a90ff3abd9" => :catalina
    sha256 "46438f2839f8258cec5593a0db9899c5dd7d9ae4c791ed0f349d6a5ab9164d10" => :mojave
    sha256 "741ef8b7a9b09ebc6cb485b6d752f5e2ea8e84643ca07aa8d2931861501f69b4" => :high_sierra
    sha256 "d2a4328e6a8e8e98114c97f547e87b248384855c9013d3b48c70a20b7d525a84" => :sierra
  end

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
    cp libexec/"examples"/"main.cpp", "test.cpp"
    # fix test, porting https://github.com/KhronosGroup/SPIRV-Tools/pull/2540
    inreplace "test.cpp" do |s|
      s.gsub! /(const std::string source =)\n(      \"         OpCapability Shader \")/,
              "\\1\n      \"         OpCapability Linkage \"\n\\2"
      s.gsub! "SPV_ENV_VULKAN_1_0", "SPV_ENV_UNIVERSAL_1_3"
    end
    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", "-lc++"
    system "./test"
  end
end
