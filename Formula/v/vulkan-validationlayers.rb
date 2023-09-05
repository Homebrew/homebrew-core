class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  stable do
    url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.3.261.tar.gz"
    sha256 "ab769d9d7550e1636c9309387a7e53be5ba89f0b19f810bb40caa1b6eaefe8ee"

    # revert vulkan-utility-libraries dependency, remove in next release
    patch do
      url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/commit/e6bdb8d71409a96a4174589ea195d0dc1e920625.patch?full_index=1"
      sha256 "5bc8e5bbae533f4d2586055fd4eccc93c2e4d7bccf5faea1fca8bae9f332246c"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f37fe2ee839a27f8f4133a2c3e789a438b79853f40f476d5435db15b88668ab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21430d3ef63936fff9b4cebaefb99c7d83afd8faee28c516acf34fa49f481cd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38fcd518903434385edcaa079c188b18c4ac1d328f9d3c1122eaaf0b8aa85925"
    sha256 cellar: :any_skip_relocation, ventura:        "3a1898951bfd3aafc075080a28f827e31692f2723291c0a28cce4bc5e17720f8"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9f8172eae3fc6ddc1a0a745424c3f1e1cdaa72c85f9a9c694eaeb3a7acccb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "37649c4755647960b8ea4c5251a2c2c9f75c13fdd1d9b475304c402df0d91b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304b76b07443da42bbd9590d719233665405123c58eeb44a68d64c78f6b00b0b"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#L57
  resource "SPIRV-Tools" do
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "e553b884c7c9febaa4e52334f683641fb5f196a0"
  end

  def install
    resource("SPIRV-Tools").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DSPIRV-Headers_SOURCE_DIR=#{Formula["spirv-headers"].prefix}",
                      "-DSPIRV_WERROR=OFF",
                      "-DSPIRV_SKIP_TESTS=ON",
                      "-DSPIRV_SKIP_EXECUTABLES=ON",
                      *std_cmake_args(install_prefix: buildpath/"third_party/SPIRV-Tools")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    args = [
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
      "-DSPIRV_HEADERS_INSTALL_DIR=#{Formula["spirv-headers"].prefix}",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{buildpath}/third_party/SPIRV-Tools",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
      "-DBUILD_LAYERS=ON",
      "-DBUILD_LAYER_SUPPORT_FILES=ON",
      "-DBUILD_TESTS=OFF",
      "-DUSE_ROBIN_HOOD_HASHING=OFF",
    ]
    if OS.linux?
      args += [
        "-DBUILD_WSI_XCB_SUPPORT=ON",
        "-DBUILD_WSI_XLIB_SUPPORT=ON",
        "-DBUILD_WSI_WAYLAND_SUPPORT=ON",
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use this layer in a Vulkan application, you may need to place it in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"

    expected = <<~EOS
      Instance Layers: count = 1
      --------------------------
      VK_LAYER_KHRONOS_validation Khronos Validation Layer #{version}  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match expected, actual
  end
end
