class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.278.tar.gz"
  sha256 "49aa09697efd39547d6983698724130175f062440dc14c601ac4c8510703a895"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebac9d8ba2a3d48b4cc25c9df6c7e15ec3f4d1e5cde319a8268898427e7501d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb676421feb5407f44ffcd0350984e36dff69fb7d59fa07d83050148a48ee871"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b39060c4da4f613953ceeca7700469e417b02b7fcab6fad2ed066426c3cb06c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "de36a46959c6c5ddf68f5f206caa4011d2b9c1bbef485a3b1d13fc705b8d0ddc"
    sha256 cellar: :any_skip_relocation, ventura:        "b46a59ebf7c5e644c798dfa9e6cfdd9605c31c1a4a110c34e0f35bf4e900057d"
    sha256 cellar: :any_skip_relocation, monterey:       "97f2049d30a6aa1f9a22ce04bdb6c2dc0e9f3cf02a8f74c0ce39cba80a7c91ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d990a8066e95002a0d1541761ad9edb860c550c7de3c734aa217f1f64d8714"
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
