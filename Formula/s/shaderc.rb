class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2024.3.tar.gz"
    sha256 "d5c68b5de5d4c7859d9699054493e0a42a2a5eb21b425d63f7b7dd543db0d708"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "467ce01c71e38cf01814c48987a5c0dadd914df4"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "2a9b6f951c7d6b04b6c21fe1bf3f475b68b84801"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "01c8438ee4ac52c248119b7e03e0b021f853b51a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b081f14c99cdb93b9e75ff5cb457989fdc8660a9e3bb764e4b9046cfcddaaa4"
    sha256 cellar: :any,                 arm64_sonoma:  "f0563a0b3c9a0ca136fbfe1d0a0218d8a61d0eab13e308a80536ced0dc2acd25"
    sha256 cellar: :any,                 arm64_ventura: "81e4be8a39cc4b197772a215230c78fb86f61c3c41898f15adb7409b991c6c98"
    sha256 cellar: :any,                 sonoma:        "d7908e7504c77cbaad0cc90c172b94b509bed194e1c82f5c01dbeb24ff1bd086"
    sha256 cellar: :any,                 ventura:       "753ab423ad44a3357d5cbef987d43990f1173e9ba95b1f0b95da7272e06b83a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810f75d4cdd8b07b1fdecd9a100fad7eb332662421c7d880feb524e0a4e03b4e"
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

  # patch to fix `target "SPIRV-Tools-opt" that is not in any export set`
  # upstream bug report, https://github.com/google/shaderc/issues/1413
  patch :DATA

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

__END__
diff --git a/third_party/CMakeLists.txt b/third_party/CMakeLists.txt
index d44f62a..dffac6a 100644
--- a/third_party/CMakeLists.txt
+++ b/third_party/CMakeLists.txt
@@ -87,7 +87,6 @@ if (NOT TARGET glslang)
       # Glslang tests are off by default. Turn them on if testing Shaderc.
       set(GLSLANG_TESTS ON)
     endif()
-    set(GLSLANG_ENABLE_INSTALL $<NOT:${SKIP_GLSLANG_INSTALL}>)
     add_subdirectory(${SHADERC_GLSLANG_DIR} glslang)
   endif()
   if (NOT TARGET glslang)
