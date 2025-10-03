class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2025.4.tar.gz"
    sha256 "8a89fb6612ace8954470aae004623374a8fc8b7a34a4277bee5527173b064faf"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "d213562e35573012b6348b2d584457c3704ac09b"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "01e0577914a75a2569c846778c2f93aa8e6feddd"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "19042c8921f35f7bec56b9e5c96c5f5691588ca8"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f13a92f1904a7217831b416a3e7272cf08e7c8c1599fc1cdf21538b5a49b8f06"
    sha256 cellar: :any,                 arm64_sequoia: "a063f7f50db8978dcb52f36dae50459daa6990e5b8fa7838543301486273405b"
    sha256 cellar: :any,                 arm64_sonoma:  "d52d1ddaca69c31d353f0d023944e47d94a3563d9c17e38b110f4bfded8699d7"
    sha256 cellar: :any,                 sonoma:        "376c3d44b2ad8a48d0921004782644cd28a5d2e0a245a6da4ce63f823829829a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569a4cc1839f7f218feaee7e28bce9816d5e613002959d872986e4d53c18d7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e1488c44b3557dad4fb152414a2a4e175e1a8a232fb7be87ffffff770213e5"
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

  uses_from_macos "python" => :build

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
    (testpath/"test.c").write <<~C
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    C
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
