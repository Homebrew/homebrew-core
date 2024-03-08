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
    sha256 cellar: :any,                 arm64_sonoma:   "7c9e9d75a35439667250ae50f061a5b0190deec55ca87699da393f5e826e085f"
    sha256 cellar: :any,                 arm64_ventura:  "bcf75d86965a3ee28d73bcc6908407745ce6947861089ef20d7b5baf43916036"
    sha256 cellar: :any,                 arm64_monterey: "228a541402e5e6a758ad63365a5ab9cf3fcd84224e9d2a168d81b4637863ff02"
    sha256 cellar: :any,                 sonoma:         "7b5c2929aa9a35a4cd4e9601801165c3ded70e82b0028c7fae45dd5ba2c1a483"
    sha256 cellar: :any,                 ventura:        "6d8afa4685485af244eacf7ce9c070295b825b49d2d773234e4e75c1cb081f1d"
    sha256 cellar: :any,                 monterey:       "3011f2f29b705b584314985a89d9ebabee34cce61a58de9fdc8ce65619bdcea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43ff891801bd6d5e46531aaac54b5e3d1974f5dc0c6d5c45eea4837c0e17d7db"
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
