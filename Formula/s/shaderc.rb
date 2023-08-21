class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2023.6.tar.gz"
    sha256 "e40fd4a87a56f6610e223122179f086d5c4f11a7e0e2aa461f0325c3a0acc6ae"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "76b52ebf77833908dc4c0dd6c70a9c357ac720bd"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "124a9665e464ef98b8b718d572d5f329311061eb"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "e553b884c7c9febaa4e52334f683641fb5f196a0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8dffc0cf4d1fb6e0e512f282b50738bbb758a365c9848f8363e8e3191b8e8158"
    sha256 cellar: :any,                 arm64_monterey: "012cb597bab3326899b421fc557e8d448c38967801fdebffe20b3af6ddcad253"
    sha256 cellar: :any,                 arm64_big_sur:  "1940d6e626ab52f840275f6eaac7567b865fd07951f04e996a144ded9b4399f2"
    sha256 cellar: :any,                 ventura:        "855d90d7e2bd7208510639342f12d95341e801c43c075a25b03d10db2dc5d5d2"
    sha256 cellar: :any,                 monterey:       "f72d775abe1053fe7e9deaa7383753ff4fb62cea91315668ba64681887f33e96"
    sha256 cellar: :any,                 big_sur:        "b58f91fba26173a7ee05a7bcf229d8b15a743bfce855eba803485267d00488d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a507c8adf294fa23564f31290811b8bb74f5976332e4457cc2d2d056f70f364"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_party/CMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
    system "cmake", "-S", ".", "-B", "build",
                    "-DSHADERC_SKIP_TESTS=ON",
                    "-DSKIP_GLSLANG_INSTALL=ON",
                    "-DSKIP_SPIRV_TOOLS_INSTALL=ON",
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
