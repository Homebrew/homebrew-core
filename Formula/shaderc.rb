class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2023.4.tar.gz"
    sha256 "671c5750638ff5e42e0e0e5325b758a1ab85e6fd0fe934d369a8631c4292f12f"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "9fbc561947f6b5275289a1985676fb7267273e09"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "bdbfd019be6952fd8fa9bd5606a8798a7530c853"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "e7c6084fd1d6d6f5ac393e842728d8be309688ca"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "dd038613145773ff320ebe3a79cf61272376281bbe06f5d7b422397fa8e649e7"
    sha256 cellar: :any,                 arm64_monterey: "a73b22ed66db948c0c4f1ba3f9e04135aa3b87e5dbe3a569fb279ed9a468c229"
    sha256 cellar: :any,                 arm64_big_sur:  "cfe7d7622353d8b805a07ca1c34e9aa7a7e5a0397d9773f8aa39f1db011cc736"
    sha256 cellar: :any,                 ventura:        "2ac1180ed8fc32957e854ab7948af61e174f5f0ad7e5075f14906458c5fff3c3"
    sha256 cellar: :any,                 monterey:       "8f03525f71176ba744eb98931831e01a7c8f53a1e78d4ea594b258df677c2ff3"
    sha256 cellar: :any,                 big_sur:        "1196194aff020b3a96f1d379c1c225efe35ec7c027be4ec53aa9bcfd48d7328d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c62c00f66b1e611964b4ca495bbe623d701c7f9845b65763f9a76536c1ab032"
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
  depends_on "python@3.11" => :build

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
