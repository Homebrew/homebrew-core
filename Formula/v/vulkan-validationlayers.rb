class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "73180b11992a3554e97ebc18e6bf2b45ff9790ded9d87fc526c7bab865d1303f"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a77e56359809bc73b5fc6491dd24ad4b11cecde64b64a5608cde480d0fd0f50"
    sha256 cellar: :any, arm64_sequoia: "444cc47f5ce0cd35ebaf2e945b05d9c4ed7ce79251876fac187d8cafa48231a9"
    sha256 cellar: :any, arm64_sonoma:  "ce01443872d6b2df90ae8cf64d3f338844cd8da14e14bbe943ef408cae77798a"
    sha256 cellar: :any, sonoma:        "5b82f581e4de04fc7ebe066f46f264096f0c20001b6606d2e3016e36093ceafa"
    sha256 cellar: :any, arm64_linux:   "fbffe3fb46bd3b8eed44b18604982a42a3db8030a423238f30ef8d868f5d1f59"
    sha256 cellar: :any, x86_64_linux:  "ef66b7f42eb0f27a5f37b8a58530698d8105ee918189cfcc1a16cee527b98beb"
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
      "-DSPIRV_HEADERS_INSTALL_DIR=#{formula_opt_prefix("spirv-headers")}",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{formula_opt_prefix("spirv-tools")}",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
      "-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=#{Formula["vulkan-utility-libraries"].prefix}",
      "-DCMAKE_INSTALL_RPATH=#{rpath(target: formula_opt_lib("vulkan-loader"))}",
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
