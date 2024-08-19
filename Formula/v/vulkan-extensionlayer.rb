class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.292.tar.gz"
  sha256 "9aa8a4eb8c12a8f39c77af29b1cf7c80705de70e8fa4cd359ed8a27f9beb95c7"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03fa3508894689ebc28de219259b013c2716f3f4cb1a8314b4dae731b6f98b51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2617860a2ae348f62bcc2e1b6443d9043a5ea223b80d72890593be9f81688a07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4aac535fbc94f7a0a28fdcf9d64d83ce3949e4bde5724443a06e2da4da90105"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8e23fe81b8c11adf442c7689da9d487cf47463db54757d66ef8db37fb9aee49"
    sha256 cellar: :any_skip_relocation, ventura:        "e1668a61e3abd2d2ccacccc6353a2bdc13bbdead2296351c07f6dcb633a803be"
    sha256 cellar: :any_skip_relocation, monterey:       "d04436bf568bee8166c0a6cb255baaeefa11d3de05273287a098d84870a3361d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d826cc71b21d7d8b4d5b614ebf94ff9fd2d4888829a4ad044377dbb8b37cd08e"
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
