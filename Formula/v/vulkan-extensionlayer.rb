class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/vulkan-sdk-1.4.321.0.tar.gz"
  sha256 "6104bcd3c81b10e5ad90749d895bd681ff411c0c5de914e53a9aa9f727c43cc8"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ddf0160cb88f835c9a1197b757fc366fa27a6df2775c15224744c7f3837d490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eeeadeac358017dd128a64ae1c1f0e30930d49e3e6643fcb9f924b7ef5b422f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1cedbea11806339ae081f2082cff16b3a0a1e5003a6885549cdac1dd7906da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "701f69b976e4530ce5481c7a88ac0dedbd39f2788dbfaefe80866975f527e1fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c46ee6c4b7967bae8de9537484727900b8dc0eb9960e6513081f733c5b5c25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfa854a1cee83a1e81c52f3feb304fe641834ff9eaf9724134559ff3a378998"
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
