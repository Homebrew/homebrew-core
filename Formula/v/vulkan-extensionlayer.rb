class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.4.321.tar.gz"
  sha256 "177a356162cfcf47c50cc0f0dcd51630196f171f21d6cefe3fb8b5d514f60d49"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa5ca295944b3c100152c8ac997a9a5a322be5a65686e1270bd54c83b1940b36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2053b993eff8b5ed5e0786d776dfb0daeb0c90fcc78963e0a7b4cf0f710661c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1df14370457b3dfe4ef7f4a32153d25329ea721481a4214538aeb6c955e7a17"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8e80912889b8536d0956664105e481fa681bfe7a3cec5664bf0d0980c9d05c"
    sha256 cellar: :any_skip_relocation, ventura:       "208e154424c6fb819d39911292c7d67a86c8ed2f33f50534924a40794ddb3b76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6123247d479ae3fd0eff943d0b0cb059d201fbe52fef6e2dfbf1188592210810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d062aa1f79e3cae8dd5de1ca1a5b7b77a3ea31eb1285b6344a281712dfb105"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
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
