class Shaderc < Formula
  desc "Collection of tools, libraries and tests for shader compilation"
  homepage "https://github.com/google/shaderc"
  url "https://github.com/google/shaderc/archive/ndk-r12b.tar.gz"
  sha256 "443c8722cc42a7ea1f79ef05a6b8451fe242508333217cdbf939bc1c202f9424"
  depends_on "cmake" => :build

  resource "googletest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  resource "glslang" do
    url "https://github.com/google/glslang/archive/GoogleGlslang20160218.tar.gz"
    sha256 "794471fe2eeb0ae0a3f0cff32b513d3c518d2235d0a0654ea4999e504f3526b6"
  end

  resource "spirv-tools" do
    url "https://github.com/KhronosGroup/SPIRV-Tools/archive/master-tot.tar.gz"
    sha256 "a53c1a78633ce39d0a8261c31caac601024f91f4a3f223bcecbe1631ef5449f6"
  end

  resource "spirv-headers" do
    url "https://github.com/KhronosGroup/SPIRV-Headers/archive/vulkan-1.1-rc2.tar.gz"
    sha256 "cad18d4f05dee13976741c379f042d0d21562bd03e9f0e1496221e2682acf052"
  end

  def install
    resource("googletest").stage do
      mkdir_p "../third_party/googletest"
      mv "*", "../third_party/googletest/"
    end

    resource("glslang").stage do
      mkdir_p "../third_party/glslang"
      mv "*", "../third_party/glslang/"
    end

    resource("spirv-tools").stage do
      mkdir_p "../third_party/spirv-tools"
      mv "*", "../third_party/spirv-tools/"
    end

    resource("spirv-headers").stage do
      mkdir_p "../third_party/spirv-headers"
      mv "*", "../third_party/spirv-headers/"
    end

    system "cmake", ".", "-DSHADERC_SKIP_TESTS=true", *std_cmake_args
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test shaderc`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
