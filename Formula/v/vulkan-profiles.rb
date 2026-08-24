class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "08494e824457659d0399075263deff22226ef2c0c1067f551b7ec84a1b11df53"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba8531a6ca81c6feed8694247f79b20c3449dce1f9da369dab1579e958d27069"
    sha256 cellar: :any, arm64_sequoia: "e9378f588eff60b4033b53e57432657b02eae60ab87a33b6c53fbbd892faaeee"
    sha256 cellar: :any, arm64_sonoma:  "b8293e8fa07a8e96129c8561c7b5c696d3bcc7977d181f818eca8348852703e3"
    sha256 cellar: :any, sonoma:        "42bc6fbc0e2ecf0bb0bb8d7cd24f4aaf588a66db3a2fcb813bd81e73ea06d52a"
    sha256 cellar: :any, arm64_linux:   "63eb783b015a564896c9d198a0564083b42e5a4973ce6c17b05709a6b2a6a098"
    sha256 cellar: :any, x86_64_linux:  "93a0602a6878a0b633d70659007f0cbca08e65bc85deafcee1d49bd2d7f4d6a9"
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
