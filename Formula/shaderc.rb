class Shaderc < Formula
  desc "Tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  url "https://github.com/google/shaderc/archive/v2018.0.tar.gz"
  sha256 "b96f27e7375a6df08732ebd47c18febf82bd0a87e541fd7814fd8c3aa6c8913a"
  depends_on "cmake" => :build

  depends_on "glslang"
  depends_on "spirv-tools"

  def install
    # port from https://git.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/shaderc
    inreplace "CMakeLists.txt", /add_subdirectory\((examples|third_party)\)/, ""
    inreplace "glslc/CMakeLists.txt", /.*build-version.*/, ""
    (buildpath/"glslc"/"src"/"build-version.inc").write <<~EOS
      "#{version}\\n"
      "#{Formula["spirv-tools"].version}\\n"
      "#{Formula["glslang"].version}\\n"
    EOS

    # https://github.com/google/shaderc/pull/463 fix build with system lib
    inreplace "glslc/CMakeLists.txt", "HLSL glslang SPIRV", "glslang HLSL SPIRV"
    inreplace "libshaderc_util/CMakeLists.txt", "HLSL glslang SPIRV", "glslang HLSL SPIRV"

    system "cmake", ".", "-DSHADERC_SKIP_TESTS=ON", "-DSHADERC_ENABLE_NV_EXTENSIONS=OFF", *std_cmake_args
    system "make", "install"

    (libexec/"examples").install "examples/online-compile/main.cc"
    (libexec/"doc").install "glslc/README.asciidoc" => "glslc.asciidoc"
  end

  test do
    cp libexec/"examples"/"main.cc", "test.cc"
    system ENV.cc, "-o", "test", "test.cc", "-std=c++11", "-I#{include}", "-L#{lib}", "-lshaderc_combined", "-lc++",
                   "-L#{Formula["spirv-tools"].lib}", "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt",
                   "-L#{Formula["glslang"].lib}", "-lglslang", "-lHLSL", "-lSPIRV", "-lOSDependent", "-lOGLCompiler"
    system "./test"
  end
end
