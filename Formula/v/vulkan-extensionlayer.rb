class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.268.tar.gz"
  sha256 "038fe8be301a7169b57c5fef7fbcdfa61a52f2b0fb3dabcf61218dfa417ba7dc"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4863eafe85a71d3f47029d5d3b1098a3a36b9ee200fc7481e8d335980fdc8841"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d44f601b9f0931f0e808e2d4e241f0da6e6cfde8e503cdad8cbdc9a9a53ef55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a2a6da2a019b87acfa9548e34e58b0191397cbeb5e1525df1c5e4f8f4d3b20"
    sha256 cellar: :any_skip_relocation, sonoma:         "6712427862da96e9a6c8e9c91c183e39c2704c38f032d55eb99a0a20dd671562"
    sha256 cellar: :any_skip_relocation, ventura:        "141799afecfc728676905d61e2beaf143ce46b5c83975b9e57a81d30b0c139bb"
    sha256 cellar: :any_skip_relocation, monterey:       "6af951d041a7c7816e9180594d82363b6dd77394da15acd34a1564e2d79f48e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b2b88f11c14db216711f4f5305d8aae413cce3482aee144c1f182933f9449cc"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"
  depends_on "vulkan-utility-libraries"

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
      VK_LAYER_KHRONOS_shader_object      Khronos Shader object layer      \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_synchronization2   Khronos Synchronization2 layer   \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_timeline_semaphore Khronos timeline Semaphore layer \\d\\.\\d\\.\\d+  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match Regexp.new(expected), actual
  end
end
