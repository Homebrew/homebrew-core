class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2025.2.tar.gz"
    sha256 "3fddc13bbb87411c6f7b8f447e87c1637933450087e70fc21da650041f4e0132"

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
    sha256 cellar: :any,                 arm64_sequoia: "d754215b97ff59175e5b49ac7583837e004d6f0fff59fedd9b42fe5dc779bd9c"
    sha256 cellar: :any,                 arm64_sonoma:  "8fb423c7f2631260378576f9f90fa830aa78e1a6f1e059da9371ad73c3570da1"
    sha256 cellar: :any,                 arm64_ventura: "ffc37dd4facbae80c0c6fd4a85621220898facaf2c2e66346d490e65302c86d8"
    sha256 cellar: :any,                 sonoma:        "cce9f7b41fbfc64373bb63c6e8b6884f635a56b531ce858bc14534c700677e40"
    sha256 cellar: :any,                 ventura:       "9c5bd57e3a5822fef1f0d42c187d9f77dd740068f8bd40d08cdb03710c29d7c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb01f0bdd6d5f06d4a0bdaa78707d30763b4f0fb3ca7815ce9790318472e10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7be1ea16a85ac988a3e25142dde846feec4477b6b6584730f8d1b3f55b5a8f3"
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
