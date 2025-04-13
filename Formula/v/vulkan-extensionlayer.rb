class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.4.312.tar.gz"
  sha256 "07b0964f833633842549e40a4c44640e70aa4f8ae27d091025447c057d05999e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b361beda399982aea50122edb7d3780038d9b15ee7081b053672ce8b51e8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd562139e05f70c47fe7014d3146a8a97c4c577a342937544bd47c56936610db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ee8783303d55d35071dc3c83c0d2d9518ee9e65ecd97ee59020b3cfb92ec7f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d45982903653dcf9d234b97f60b776cf0e5af69c704d0f355b275d4d2472a4b"
    sha256 cellar: :any_skip_relocation, ventura:       "bbc87fe1783128649eecb81451999e1090767ab34049a8ccd7ec3384040fe3f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "720e0dce56aed66b68544d3eb9f19fad6b0d49b6daf0454c44fa9912a0953b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f8a1f815df7645ae52c36e6e9ce5db1bd6d3add58a3ce60cee82010e301976"
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
