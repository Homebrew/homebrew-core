class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2023.8.tar.gz"
    sha256 "dfec5045f30d8f6d3d3914ab5b3cc2695947f266d41261b1459177cd789308d1"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "a91631b260cba3f22858d6c6827511e636c2458a"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "1c6bb2743599e6eb6f37b2969acc0aef812e32e3"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "f0cc85efdbbe3a46eae90e0f915dc1509836d0fc"
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
