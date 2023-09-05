class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.261.tar.gz"
  sha256 "970944aebdc8cabcfc381ea722e67576e243bc3cde7ec71e6f2dd9e026d50b2a"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21b4e4ed8cede82cff923ad83aef8adb2f678da250b668457d528bf742e0ae6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdb3dfc18fc4db787d451a5adb5857b5352cc4bfd192cd444ca8189b1b87d777"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b297dd4f3982213a5c3a98c58c9d9ea48e004dc67af2438c44f2133d704fb0aa"
    sha256 cellar: :any_skip_relocation, ventura:        "27214b1800a1de88e1014550aec721c8f105407358142709c51b07a1cdcd8351"
    sha256 cellar: :any_skip_relocation, monterey:       "4ca25bc8243e3e2919f1742f78a745e0110f5dadbf9399aaaffbf67c1fdc78b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f7e7676a0525ba305094b8d96b7539512c847f59d7ba4f4ca7cd1a8ea1405c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ab5563873ffab411989ee9d6cf0f0a3f0c9c4478cf072de815b3a64582fcb8"
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
      Instance Layers: count = 3
      --------------------------
      VK_LAYER_KHRONOS_shader_object      Shader object layer              \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_synchronization2   Khronos Synchronization2 layer   \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_timeline_semaphore Khronos timeline Semaphore layer \\d\\.\\d\\.\\d+  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match Regexp.new(expected), actual
  end
end
