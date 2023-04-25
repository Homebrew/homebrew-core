class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.248.tar.gz"
  sha256 "aa41c89691a97ae7eee7f22d18dac897c9ddb3f876d9876cb6735fa54fcea3d4"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e674d1f988822cdeabcfe006f5bfcb3a51b57b043811d1f8504cc2eb4bf8ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21337135c2c76afe56ba34f974ad261033ef17e923d50176f117355306ef0032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f78a6f47202bbbdd34664171a718b1a6e330946d49c8250dba63b6f2ac220141"
    sha256 cellar: :any_skip_relocation, ventura:        "734c47f98b7c71c7fa7d7623c733ed07793f6e439993c7d1ff64b31c7c963611"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7ff0c9d2eb011072668e3e45052cadedfb8ba1af1bb9d97a07f7a992a53248"
    sha256 cellar: :any_skip_relocation, big_sur:        "07b57f9d33ff0183dd0d10191b39939e6bc9e9a5600fe84ae16fcdbce5deafce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fceb982ebfce1763c212191cf5003b6abc47fe7cff3878b490527c75fdf9513d"
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

    ver = Formula["vulkan-headers"].version
    expected = <<~EOS
      Instance Layers: count = 3
      --------------------------
      VK_LAYER_KHRONOS_shader_object      Shader object layer              #{ver}  version 1
      VK_LAYER_KHRONOS_synchronization2   Khronos Synchronization2 layer   #{ver}  version 1
      VK_LAYER_KHRONOS_timeline_semaphore Khronos timeline Semaphore layer #{ver}  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match expected, actual
  end
end
