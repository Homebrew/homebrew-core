class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.4.305.tar.gz"
  sha256 "cda4e89f54afa7ededbe73a41a30ce51306418e7cbf2635bfa0222c40d362656"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f3dde487029a81a4df661a9f6e50ba2927fe23399efd97648a6b2002cbf1d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c896256de712883a1c1687d4b5cdc5bc1ce08df5747d5008f42438dbc0b1fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23a2b69a265c913c739115a94d5b7427ef3ba1aeb04b637b52f1e64843a690d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dc62d3ae182ce2537ec28a40e90ff48f351c6d77db22bfe09213a117cdc9ba0"
    sha256 cellar: :any_skip_relocation, ventura:       "648a93e803a6e8fc4634f93120b368105f025049eb0c540f24e8a79c7feafd84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1e06afcc1489e74cd03c7c93f8182bff399f0df724199fa76738f12b2f720d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
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

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#L32
  resource "SPIRV-Headers" do
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "3f17b2af6784bfa2c5aa5dbb8e0e74a607dd8b3b"
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#L46
  resource "SPIRV-Tools" do
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "4d2f0b40bfe290dea6c6904dafdf7fd8328ba346"
  end

  def install
    resource("SPIRV-Headers").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"third_party/SPIRV-Headers")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("SPIRV-Tools").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DSPIRV-Headers_SOURCE_DIR=#{buildpath}/third_party/SPIRV-Headers",
                      "-DSPIRV_WERROR=OFF",
                      "-DSPIRV_SKIP_TESTS=ON",
                      "-DSPIRV_SKIP_EXECUTABLES=ON",
                      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
                      *std_cmake_args(install_prefix: buildpath/"third_party/SPIRV-Tools")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    args = [
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
      "-DSPIRV_HEADERS_INSTALL_DIR=#{buildpath}/third_party/SPIRV-Headers",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{buildpath}/third_party/SPIRV-Tools",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
      "-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=#{Formula["vulkan-utility-libraries"].prefix}",
      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
      "-DBUILD_LAYERS=ON",
      "-DBUILD_LAYER_SUPPORT_FILES=ON",
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
