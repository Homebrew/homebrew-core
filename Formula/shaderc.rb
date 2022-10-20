class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2022.2.tar.gz"
    sha256 "517d36937c406858164673db696dc1d9c7be7ef0960fbf2965bfef768f46b8c0"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "f771c1293dce29e1ac3557cf994169136155c81f"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "0bcc624926a25a2a273d07877fd25a6ff5ba1cfb"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "3a8a961cffb7699422a05dcbafdd721226b4547d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "174b4530be3be6516e880e96c10cc1076ea951417e145a293163680bd98fa833"
    sha256 cellar: :any,                 arm64_big_sur:  "e8947021cb1ef2e7a79ea4a64ca3050cd94737adb6b6b89f94dcaf34c5387bb8"
    sha256 cellar: :any,                 monterey:       "201b023ce23b2c17eba2395505373630d0688e76d9cce84c0fd334ae2f0f96a7"
    sha256 cellar: :any,                 big_sur:        "185a7010cd011457e222d5a93c455ddeb9bb1f1848f8a2d9ccb6e8d233e631ec"
    sha256 cellar: :any,                 catalina:       "32b45ff6b653221cb9e4c95169e8f6b5a07564f87e9b8a1574d054e218fd2b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4ab5e9dad1d76e4419f8be1204ca5bc0000b13b30dee9108b4a9c2a9683245"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git",
          branch: "master"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          branch: "master"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    system "cmake", "-S", ".", "-B", "build",
           "-DSHADERC_SKIP_TESTS=ON",
           "-DSKIP_GLSLANG_INSTALL=ON", "-DSKIP_SPIRV_TOOLS_INSTALL=ON", "-DSKIP_GOOGLETEST_INSTALL=ON",
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
