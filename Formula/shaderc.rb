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
    sha256 cellar: :any,                 arm64_ventura:  "9b1e84e35ba464b0e83dc0b600f78638783bcb2896717497967cd3205ea65ab9"
    sha256 cellar: :any,                 arm64_monterey: "6ec70e454f35b2aa07b7caef474acf75f3f01cbe2167ebec3938e2ee2b2bb127"
    sha256 cellar: :any,                 arm64_big_sur:  "7c767f337722091e531ba16a019025cd7625646dd4df2ca3a58d30f220b9b4bd"
    sha256 cellar: :any,                 ventura:        "40bd530cd98d7678c633a2d4107f56136376557da28bfc5124b984655619a99a"
    sha256 cellar: :any,                 monterey:       "b11bd7af6bba9a2f7a945c715daafd413408a3c79933a34c4091a87dfda1393a"
    sha256 cellar: :any,                 big_sur:        "6d09c445492d74a12e73357f396545f4dbf4dacecf5b80994eb80cb31385bb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30f29c912b3eb6d8bcff67c276f390f7fa7e1e9e4fb6d02842ab5c6abdf252d3"
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
