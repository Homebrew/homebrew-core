class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "4905ae2d2424cccdd88554b78f6f53e3469da17433c3923d049a167ea674f50e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03ca43fbbad6e56170328e4989565c000d1f7d5a3d58555ee885ca59d5bd8136"
    sha256 cellar: :any,                 arm64_sequoia: "4199eec50aaee407a368de33c20915c1d713be9f6856f84224f2ed6ec7b97f23"
    sha256 cellar: :any,                 arm64_sonoma:  "549656ce6867741a1c2edba161818ead9efdd4f81e03b10f43473bd0d7a620e5"
    sha256 cellar: :any,                 sonoma:        "8c8158bce2dfd213357a2eaa5ae50daa5e74d08d94e7fecfc28b80148654eaa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633516170650318cf21c8577b44adca19de0cf8bb846f87ef36c6ada8b4425d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59908db9ea87a217b32d93f45ff2262c153da6d5df71268300b0238307fecf85"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers" => :build
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "vulkan-utility-libraries"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkgconf" => :build
    depends_on "wayland" => :build
  end

  def install
    args = [
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
      "-DSPIRV_HEADERS_INSTALL_DIR=#{Formula["spirv-headers"].opt_prefix}",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{Formula["spirv-tools"].opt_prefix}",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
      "-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=#{Formula["vulkan-utility-libraries"].prefix}",
      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
      "-DBUILD_TESTS=OFF",
      "-DUSE_ROBIN_HOOD_HASHING=OFF",
    ]
    if OS.linux?
      args += [
        "-DBUILD_WSI_XCB_SUPPORT=ON",
        "-DBUILD_WSI_XLIB_SUPPORT=ON",
        "-DBUILD_WSI_WAYLAND_SUPPORT=ON",
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use this layer in a Vulkan application, you may need to place it in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"

    actual = shell_output("vulkaninfo")
    %w[VK_EXT_debug_report VK_EXT_debug_utils VK_EXT_validation_features
       VK_EXT_debug_marker VK_EXT_tooling_info VK_EXT_validation_cache].each do |expected|
      assert_match expected, actual
    end
  end
end
