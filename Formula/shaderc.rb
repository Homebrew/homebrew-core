class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2023.2.tar.gz"
    sha256 "06c4e2fdd63d62b73450d7011b72e7720b416182fb883fb0aac0afe6db2df3f6"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "1fb2f1d7896627d62a289439a2c3e750e551a7ab"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "d13b52222c39a7e9a401b44646f0ca3a640fbd47"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "63de608daeb7e91fbea6d7477a50debe7cac57ce"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76411e843aba872ac290a922f6087a92e422e60816309e683455a66679e8e2c9"
    sha256 cellar: :any,                 arm64_monterey: "880246217be2e073f5f464b42085994e28bd9ac8bf8452948b41c4a575588133"
    sha256 cellar: :any,                 arm64_big_sur:  "e64a8d915f8196861a510e6823705a73b4ef2d853d92b26542a5a2276a007aa7"
    sha256 cellar: :any,                 ventura:        "e098d27c7c895eb66e4bd9d91e4773f9a69890a6aa5f3dd90c819d58f7e67e4b"
    sha256 cellar: :any,                 monterey:       "4dfe9c6d38e456536811f622d944dba4a7066fe7c5da9ff192b28e5bb0cba773"
    sha256 cellar: :any,                 big_sur:        "5a1756999ac62754ec6dabe4f7b334dd1d0c6a0ae2dbec6598e1825b29ef447a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f14fe27ad1a7497a3f113d85fcc2feafceb78bcb00a8b8de853ff27a7b6de6"
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
