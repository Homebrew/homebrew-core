class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/vulkan-sdk-1.4.350.1.tar.gz"
  sha256 "6cab94e281a5a5596161147a96cb8d2e6efc94b7fe88b1b1a7c21c7166f46f5d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3250ed5bde937a62b973001d9c3ee53cc6af35115e2b95fa45e0a0475016bfad"
    sha256 cellar: :any, arm64_sequoia: "a87582a3ea570d6737a4f1189b3ccb1dd0b1d6a50c2c4ca0cc854d3788e314bb"
    sha256 cellar: :any, arm64_sonoma:  "75b02b3f918ab9e7c4885055eb7a9695c7168ccb25296efb2814ec49a2cd7b8c"
    sha256 cellar: :any, sonoma:        "242334ac664730434185ad6a907a86d191f3120745f1a7b625edb61c4cae3a4f"
    sha256 cellar: :any, arm64_linux:   "0e3a7ff80e9c6f471412a89600c9bfe75cfa360ad2a3768b2681dc0b7415add8"
    sha256 cellar: :any, x86_64_linux:  "c0f0ec43d930c47d7dec836d3d44550b4c6447241ce4a8d94f0d251c4aa19118"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "vulkan-tools" => :test
  depends_on "jsoncpp"
  depends_on "valijson"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "vulkan-utility-libraries"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "molten-vk" => :test
  end

  on_linux do
    depends_on "mesa" => :test
  end

  def install
    # fix dependency on no-longer-existing CMake files for jsoncpp
    inreplace "CMakeLists.txt",
              "find_package(jsoncpp REQUIRED CONFIG)",
              "find_package(PkgConfig REQUIRED QUIET)\npkg_search_module(jsoncpp REQUIRED jsoncpp)"
    inreplace "layer/CMakeLists.txt", "jsoncpp_static", "jsoncpp"
    inreplace "profiles/test/CMakeLists.txt", "jsoncpp_static", "jsoncpp"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: formula_opt_lib("vulkan-loader"))}",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DVALIJSON_INSTALL_DIR=#{Formula["valijson"].prefix}",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].prefix}",
                    "-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=#{Formula["vulkan-utility-libraries"].prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use the provided layer in a Vulkan application, you may need to place it in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    # FIXME: when GitHub Actions Intel Mac runners support the use of Metal,
    # remove this weakened version and conditional
    if OS.mac? && Hardware::CPU.intel?
      assert_path_exists share/"vulkan/explicit_layer.d/VkLayer_khronos_profiles.json"
    else
      ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"

      # Disable Metal argument buffers for macOS Sonoma on arm
      ENV["MVK_CONFIG_USE_METAL_ARGUMENT_BUFFERS"] = "0" if Hardware::CPU.arm? && OS.mac? && MacOS.version == :sonoma

      actual = shell_output("vulkaninfo")
      %w[VK_EXT_layer_settings VK_EXT_tooling_info].each do |expected|
        assert_match expected, actual
      end
    end
  end
end
