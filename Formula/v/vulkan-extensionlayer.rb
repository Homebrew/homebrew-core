class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "ff0e13f11d13ae260acd30e257d2e71d42cb2b2d7e95de92c6861a7c077e54be"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8de981d925cc47fb75aa28ad216b4d67038dd5781ba20c0c21beb83e5352d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e354b377744e75a78309f0f4da136947e44d347abbbcef7db5380dd0c4535e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f00d077e4d9bab1af499b628372cd895172fbef29e301097908283b6a39e82e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9236497b10395a6781b1b77ffd9d0c3d8ca425d158d526512e7e27b83a57e708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8800a285379a4406efa7c684cfedaec399606d7b8cd70165b64c4f5f912ce51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23af430352ec6f2a202a1ce4d9c79ba4e48a176bcaa275348165f968125501d7"
  end

  depends_on "cmake" => :build
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
    depends_on "pkgconf" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
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
