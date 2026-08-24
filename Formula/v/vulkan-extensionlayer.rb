class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "9187eaa5950f8d06ebbafded16266fc4b35d224e84207b249ba5f5d1be6c9eb9"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81662e1a3f3bde3f419a98a6f56d0ade625b6f6567acefa57b5470f439687c26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a9c1a7a983ea3bece200641ae90a50964cd3ed604741ce1816fc75685ac5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72f5b02ec48d19785445aff55188b1aa445644487f5f94e36a5a84222c26883"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa5d9c30754ce82f64a1a4722e3297cdab8f7f64ca18d00a19c87dec393a4542"
    sha256 cellar: :any,                 arm64_linux:   "b4d1edff941f6c3395fa280c1e64645f2f0ae5a16f77980da56d610bd1d85bbe"
    sha256 cellar: :any,                 x86_64_linux:  "3185402e1e964d10e38def34299488cff4b67a73c84d1deedb96d7ff7f2407a8"
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
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: formula_opt_lib("vulkan-loader"))}",
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
