class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2024.0.tar.gz"
    sha256 "c761044e4e204be8e0b9a2d7494f08671ca35b92c4c791c7049594ca7514197f"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "d73712b8f6c9047b09e99614e20d456d5ada2390"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "8b246ff75c6615ba4532fe4fde20f1be090c3764"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "04896c462d9f3f504c99a4698605b6524af813c1"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e91b9ca535fd4f4251290a9f05aab1d3714ddcff8a64e7f1fad846cf668ad03"
    sha256 cellar: :any,                 arm64_ventura:  "f88f181544dd8ec38a3a8205183dd8ec02c7b89cd2c252266dd9bd980f5dac23"
    sha256 cellar: :any,                 arm64_monterey: "b780f4fadce463d060e6cb9edd9478b1cceef8005295fa108f61768e42fe3ba5"
    sha256 cellar: :any,                 sonoma:         "bdeb7745584aadc9a24a10f9c7db8b4a4f4e7baadc02d10f3e884295d138ebe3"
    sha256 cellar: :any,                 ventura:        "a2d99fa5c1d74b5c01ca09f6fd1924b76df3a4a383da5bcf1a348f14198b4b7e"
    sha256 cellar: :any,                 monterey:       "1a2b71042aa305fa2a879dd06554e047c40ddbb876abe116304f2565eccd5794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "757ba7d2e4c50e297b9dce66251b273968628b14e574399b58b67f0710f4e5a5"
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
  depends_on "python@3.12" => :build

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
