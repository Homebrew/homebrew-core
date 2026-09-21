class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2026.4.tar.gz"
    sha256 "f06ce5bcca94e5df7f34e115743597d0ad2e13c5fe9213c67dc8c76031241947"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "e1b562a8bed273a02f30b59b66a5d499793cede5"
      version "e1b562a8bed273a02f30b59b66a5d499793cede5"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']glslang_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "04fd3caa1e8267e4d95c806cad901181728e1006"
      version "04fd3caa1e8267e4d95c806cad901181728e1006"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']spirv_headers_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "ef96ed763b43b59b33b31b362f09a02b729fa1c9"
      version "ef96ed763b43b59b33b31b362f09a02b729fa1c9"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']spirv_tools_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "463549d39c59ba245f05379667d89e83f223f1b035226926534fc28ede01455e"
    sha256 cellar: :any, arm64_tahoe:       "12ba0c59a98fb8f671f9473573002b2a812f26d2e60ea4f577f0c8c750c9838a"
    sha256 cellar: :any, arm64_sequoia:     "1313ffbae9ac1559f7160cc89657ecd5fc324895ff46e15a4bd198ec3bbebec0"
    sha256 cellar: :any, arm64_linux:       "9ffed598e151f5e279f58a041bd3cea982d2bad8d9f04a7b47abda96f2cdaa14"
    sha256 cellar: :any, x86_64_linux:      "65e6b619e6cf08aefe36198634c19443f3abde8e1db49ab25dc937884e9f9f80"
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

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_party/CMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
    # patch to fix `target "SPIRV-Tools-opt" that is not in any export set`
    # upstream bug report, https://github.com/google/shaderc/issues/1413
    inreplace "third_party/CMakeLists.txt",
              "set(GLSLANG_ENABLE_INSTALL $<NOT:${SKIP_GLSLANG_INSTALL}>)", ""

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
