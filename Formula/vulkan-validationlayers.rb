class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.3.247.tar.gz"
  sha256 "f24b37ada8545389239b7fb3caa5e2dd93acede96c23a471dc8dd8cbae2bcbf9"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "485d831b0e8e5023469d700f3814f3616d818e2421698f0ae4d2d700ad39a7f6"
    sha256 cellar: :any,                 arm64_monterey: "a9be726a917a5d858f500d39e375f94e10c0a099cf2b07241607efa9bf85a0f3"
    sha256 cellar: :any,                 arm64_big_sur:  "5b0b441797173f64321b1b411e54a2be959cbd0850111a021c81bd9a870f2602"
    sha256 cellar: :any,                 ventura:        "e7ec1b0ab19458b1f9c93d7e3dc1a14396f0a69ed64601a3ab2737120b7e7c71"
    sha256 cellar: :any,                 monterey:       "c5a3251f32e8e117325c4cbf473fe4b4ca4a9d83595a51d14ea4286d0f0005f2"
    sha256 cellar: :any,                 big_sur:        "39a94e7ad88c9019a272b4e726dc825d1f270d5168946c47b9698d7b8291a700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99940a98424fd2bbb6ac2b50cca23054264b023d094be90d0a04a2bb042f5422"
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
      VK_LAYER_KHRONOS_validation Khronos Validation Layer #{version}  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match expected, actual
  end
end
