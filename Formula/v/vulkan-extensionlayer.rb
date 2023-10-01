class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.263.tar.gz"
  sha256 "7396834f65401055762e852df61378a1a0a410d1c3214cca4b2201fc251b1392"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3118eac366699b2162e5d7547cc99cf18fc2abacb137ac39938cdd748e705b88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c98d9767aa73a397b373364e7abdb03bd80800a58d257611986bd18fb38b7fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4b8d67148158aac7e7faf32449ead527387296846c34456f794e7a442a8ea51"
    sha256 cellar: :any_skip_relocation, ventura:        "3c66c5d3dfd23331d8603a8d53ea7cf6b81bee5468dbb88c214983491d52b25f"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf6b8fa6bc07240d85e1ab9675972f3dfa56d3937a1c87efb203f8af13c8c02"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bc018dc7efdf6816c8d0e0687fb519fb314e09d81bcbc3b87a7656d0c4be818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf94969147cdfac9de29376663c8a35b9521e3cc5816d41251c0f7b7f950072d"
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
