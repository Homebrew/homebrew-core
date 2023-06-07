class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.250.tar.gz"
  sha256 "9c77604b06df1e2f2432cd0c3b3c0df8cf0a3fdfe63c4aac65020a6429929aff"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbb288ab5e3d83bff84030786a37564e4f075f35d82943db027c19f63db81d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a1ab68856add5671da320f4d2a8fabee1421445ba3b9e09d3a3975210f9f574"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8093372fb8385adf762c2865a263a66d637e8d77aa4d4ad1b1c85c07953c1a84"
    sha256 cellar: :any_skip_relocation, ventura:        "c7dc9cec4cf784dbb0709a2ed81d5695c15bf0cd5b9c67d8f75aeddc33dfbf76"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3801ac99581479d0cb5fdd18a87d8755361997ebf51fb3ef7e4ca9ec9fd0f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d7ab812e5531d68cdfa6e42dd6a11b6803b5d6a92a10d77b7c37e6d449b7c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c823a83d302ff89c0b728ec8027f5f582ca3eceb39102f3b765540f32a312d8"
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
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
                    "-DSPIRV_HEADERS_INSTALL_DIR=#{Formula["spirv-headers"].prefix}",
                    "-DSPIRV_TOOLS_INSTALL_DIR=#{Formula["spirv-tools"].prefix}",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use these layers in a Vulkan application, you may need to place them in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"

    expected = <<~EOS
      Instance Layers: count = 4
      --------------------------
      VK_LAYER_KHRONOS_memory_decompression Khronos Memory Decompression layer \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_shader_object        Shader object layer                \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_synchronization2     Khronos Synchronization2 layer     \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_timeline_semaphore   Khronos timeline Semaphore layer   \\d\\.\\d\\.\\d+  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match Regexp.new(expected), actual
  end
end
