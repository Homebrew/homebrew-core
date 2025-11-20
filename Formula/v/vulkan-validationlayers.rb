class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "91d9be1347a270288bcc50206bda8ccf6aad33bab8318c0643dd36bef97478f9"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4cadbbe3c6c4eb854d5918df5fbfdf68acf56980e6145169474f5f19c7835e8b"
    sha256 cellar: :any,                 arm64_sequoia: "04776b0c10645c93630cb549cafa8baa7d10bfb54e9ae20a092256f43ac1d9a0"
    sha256 cellar: :any,                 arm64_sonoma:  "0891798fc2906b4c4f20e20a3c284452c7353c6b38dabfa6bf1c7878f644c91f"
    sha256 cellar: :any,                 sonoma:        "f59c2b9f61e6ef5354c82ac2e9ef51014b9b5b884878474c846344446f7593a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "887726bda3fceca312ed20356e3414b7f405c42d55cc9f5918c0bc138fa4ed66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa355cedf002ed9cb336d7f2991ee29109590dc58ee6ed334669094e646dce4"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers" => :build
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "vulkan-utility-libraries"

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
