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
    sha256 cellar: :any,                 arm64_monterey: "6910dfdccbcfc9092e8d645b5e66d265e290b5e7c82411fb711a8b2747d235fb"
    sha256 cellar: :any,                 arm64_big_sur:  "3afe734884220af44d741483c11c0168b46caf3b8c569a76e1d90475d0c55eb5"
    sha256 cellar: :any,                 monterey:       "cd400f3167c434505425f27540924cacb654e2efc3c34774c1ed1827fdc8700b"
    sha256 cellar: :any,                 big_sur:        "19d0467ae8b31be08fe38f0c366170e1b5d562553f2ebd607ca826fe1f4b4c81"
    sha256 cellar: :any,                 catalina:       "042e6e2b2ae01104cbd38941b3eac2d43c0eb18b36a8692216b152436240a654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70925765348d09b68bf56d300086dc064a2f558a5e3697d6229ad880f04fff8b"
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
