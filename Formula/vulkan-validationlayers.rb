class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.3.250.tar.gz"
  sha256 "1c3609321c1167f9af5d3687a443885e2cb1e8e5150df16356200e84bef685f3"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a0b7c4feb0803c33f7c3e993a7cbd2535922567ecdf640a77acf0461d26cf388"
    sha256 cellar: :any,                 arm64_monterey: "ed70aee85d1cb98a93f1fb7e443d06351abcd3e157f250a6f43697e1f91ac91a"
    sha256 cellar: :any,                 arm64_big_sur:  "71ab88ceb2441185c2d62a3001b02ee2eb5d2b30c2c0688e535c8054eae13888"
    sha256 cellar: :any,                 ventura:        "37253937aae7cf18e604553466c1a5759c072036f1672b7e458b02082d339767"
    sha256 cellar: :any,                 monterey:       "155f8f3fbcb9d59e312b87b9aae5dd83c5b4d7ff84b01b1153581ef561d38332"
    sha256 cellar: :any,                 big_sur:        "cf67856781b21d793ca1d6e0718c257da40fe25bd2dfb6d2280c15fa94b3d949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dca669713a26968559cbbbc7f13886261901bce8efcdccf452151796fdea208"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  def install
    args = [
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
      "-DSPIRV_HEADERS_INSTALL_DIR=#{Formula["spirv-headers"].prefix}",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{Formula["spirv-tools"].prefix}",
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
      VK_LAYER_KHRONOS_validation Khronos Validation Layer \\d\\.\\d\\.\\d+  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match Regexp.new(expected), actual
  end
end
