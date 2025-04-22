class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2025.1.tar.gz"
    sha256 "358f9fa87b503bc7a3efe1575fbf581fca7f16dbc6d502ea2b02628d2d0d4014"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "8b822ee8ac2c3e52926820f46ad858532a895951"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "54a521dd130ae1b2f38fef79b09515702d135bdd"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "f289d047f49fb60488301ec62bafab85573668cc"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cab87874a6aabc3902e05187031a4534821de567b4508e563daa82992f32642a"
    sha256 cellar: :any,                 arm64_sonoma:  "3697d2825e3bf9cd30c0bf2af7838006fa8dff561837364c3b9e61888c444992"
    sha256 cellar: :any,                 arm64_ventura: "f899564c376e443f5b61e97e22052284aa35b615d5df1ecfcb3834f79f1877c5"
    sha256 cellar: :any,                 sonoma:        "8c0a39a316f5d90216185a968e486821d44888bf31a366bde7be8e1da74ebb3f"
    sha256 cellar: :any,                 ventura:       "608fbddc83cf6c8433d832e57d14692ba3e363cc326278f18df8894d3d162ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdea790f75cce457cf9ef72b881df5b7b31b6a0acd57fa77a4d2a6412b3f9d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b838c19717fe8f12592931432ab34f078271eccb6319fd7715d22361113eb43f"
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
