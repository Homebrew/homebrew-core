class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2023.3.tar.gz"
    sha256 "7f66435c59797cdc6370dc97aa5cab21651385ac6c5159975566d51cc3e6650f"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "ef77cf3a92490f7c37f36f20263cd3cd8c94f009"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "1feaf4414eb2b353764d01d88f8aa4bcc67b60db"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "44d72a9b36702f093dd20815561a56778b2d181e"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b07e4752ecff2c1f3fb8f4ef92aaabb256f8a2629f4d9df6762125b275d7eee"
    sha256 cellar: :any,                 arm64_monterey: "a9fb7900064768b74595b7f6b0d379638c46d4b383cbd594fc3c59c8ed7d7fd6"
    sha256 cellar: :any,                 arm64_big_sur:  "ce0b990d8da45738d67fe0e602ed316323f4985586c5e0b7ec5f4ef93a4d16ec"
    sha256 cellar: :any,                 ventura:        "ca5fe4eb1799ec598d40c99e10cfacb8fa791d3665899ed0cebcee96b343d4cc"
    sha256 cellar: :any,                 monterey:       "b6e9c5be72c5251d6fe499191ed50353cd4ae7f813bf1989532de56d2de40e37"
    sha256 cellar: :any,                 big_sur:        "b4109db413fc33139f7e68cff51c738f35fea7b689424a254d2128303ac0dd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94355b357e3ecd3aae2abd3dc7fa1f3daa6b09ad171050bb175dc7d447fb7076"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git",
          branch: "master"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          branch: "master"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "spirv-tools", because: "both install `spirv-*` binaries"

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    system "cmake", "-S", ".", "-B", "build",
           "-DSHADERC_SKIP_TESTS=ON",
           "-DSKIP_GLSLANG_INSTALL=ON",
           "-DSKIP_SPIRV_TOOLS_INSTALL=OFF",
           "-DSKIP_GOOGLETEST_INSTALL=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lshaderc_shared"
    system "./test"
  end
end
