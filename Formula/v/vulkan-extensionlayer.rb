class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.277.tar.gz"
  sha256 "05815a88b8ab7fc2bf46093eaa9fa1bfd18e36877b6b25f13d751ca6113e1e9b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d48b1f9e1fce6a51be381816db28d92da91f6ae48f2a7ee37995bb3c0ae66eed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeb8aabff9f57eebe614564b78444d08dc7abcf8d39e74f75df9431e22cdecc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2e7c86d8e06a77d64f4b78ec61e097149ecd571c9d1a2652ec9a0e6a1fdd902"
    sha256 cellar: :any_skip_relocation, sonoma:         "2373bca1e21d6ca77f51a7c58f8ff4a6528ac792dc64992a44d49a56caa71aa0"
    sha256 cellar: :any_skip_relocation, ventura:        "c6cd94f1e11434b29edb56024845ff5316e37cbde52186a4a3af1c4a643a2d32"
    sha256 cellar: :any_skip_relocation, monterey:       "5c8b89534a9b336cf28cf1b88e6f0f0a3860fc89d9ffb89d432f760ef4d4dbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c8829ced3ee62c0b57548e4d64417f4f7f35ad94cf0c09e52e06a48f3bf2c7"
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
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
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
    ENV["VK_MEMORY_DECOMPRESSION_FORCE_ENABLE"]="true"
    ENV["VK_SHADER_OBJECT_FORCE_ENABLE"]="true"
    ENV["VK_VK_SYNCHRONIZATION2_FORCE_ENABLE"]="true"

    actual = shell_output("vulkaninfo")
    %w[VK_EXT_shader_object VK_KHR_synchronization2 VK_KHR_timeline_semaphore
       VK_NV_memory_decompression].each do |expected|
      assert_match expected, actual
    end
  end
end
