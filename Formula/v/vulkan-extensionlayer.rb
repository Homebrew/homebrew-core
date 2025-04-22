class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.4.313.tar.gz"
  sha256 "14fdaf5cbbc02ce7dbacbaadeb1e9d63dc49f07a32214c4995ea9909bb534dc1"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94de775374c14ed11217384b6254f6a5752dd7da4682146e6260dbfb67e647f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed2803c127bdf92346161d90b523eac3b9541ef0f1faa1731de91f1cdbd7084e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef1bf5af371ed8e0b45490ca766fcc5e70423547a34506d8ec0db4211e46940d"
    sha256 cellar: :any_skip_relocation, sonoma:        "48802535b932b6faac60aed5f4c6512c969c16658f2bd5a143ef46b6a9532a97"
    sha256 cellar: :any_skip_relocation, ventura:       "c197d49fb984513cdc2a402aaf7483637c4b425b6c17297d9bca708734cea046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b969ae8151ff0867f34ab860a927694d6026427d02f49a2e36d97a75268be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8869b5eb81a56ca9d8f22b854949acd1081af27cbeb671ca58622fbf65256782"
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
