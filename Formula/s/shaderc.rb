class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2024.1.tar.gz"
    sha256 "eb3b5f0c16313d34f208d90c2fa1e588a23283eed63b101edd5422be6165d528"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "142052fa30f9eca191aa9dcf65359fcaed09eeec"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "5e3ad389ee56fca27c9705d093ae5387ce404df4"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "dd4b663e13c07fea4fbb3f70c1c91c86731099f7"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c8a29c3a0edd76d3ae6e59037f48eb83e30f63083e1949838b5fe01a3224f5d"
    sha256 cellar: :any,                 arm64_ventura:  "6210cc389dffb86e727d2f3f166d73b6c7d150e8f2e7d5c2866ae7cc5cd6772d"
    sha256 cellar: :any,                 arm64_monterey: "996f8926a4ad55b1c2be2f4b7b92642fb8f39d9f7995df67d5cce9a43fc4e60d"
    sha256 cellar: :any,                 sonoma:         "2c42b9747e28eee0093509b01017f732f9e78882698a8a271d750cb639e6d98e"
    sha256 cellar: :any,                 ventura:        "0eea89915c9c734b2f08383ab163cf597e6f7f93279e0b3a451dd0060682ded3"
    sha256 cellar: :any,                 monterey:       "6e7c1f25ca71fde54b5ce354c34cb8e371671fd34ab553a213a639e4cfb520f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c71813d88205305292164d9b47f3df20e810edab06b5f144a0d8d67fd33c00"
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
