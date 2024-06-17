class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/v1.3.280.tar.gz"
  sha256 "05bc8adf326131f54b236cb542012360eb0c78ef5897c9f69fea44344e440c5e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef072b4ff9243b17e5b1d749ea6fd8953cc390220aa8b67c6ee4e19cb6e0e860"
    sha256 cellar: :any,                 arm64_ventura:  "ca82d7e86ba2f8d5a6bc489fc93f473833f6d8dcf373f37324ad23f8a83e62c0"
    sha256 cellar: :any,                 arm64_monterey: "c1c7011cc6b630e84e13f7a5489368f78e38512ceca51240dd6de93867eecc79"
    sha256 cellar: :any,                 sonoma:         "a62b3c7a8b7be704b279231a1897bc30219f479c3755ae2785a51230cd06b626"
    sha256 cellar: :any,                 ventura:        "8347082bdd18e7f7b0f982706571f5e620d384941e88442ba29fa73992b9e658"
    sha256 cellar: :any,                 monterey:       "92ba182d89595b74430930dc3bfb21e958f979de943bd2ec51fd161cb3790fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9340196f5c32b812f7cd3643cbeefb0bd58e597395e9478663fcdcc59e64daea"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-tools" => :test
  depends_on "jsoncpp"
  depends_on "valijson"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "vulkan-utility-libraries"

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
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].prefix}",
                    "-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=#{Formula["vulkan-utility-libraries"].prefix}",
                    "-DVALIJSON_INSTALL_DIR=#{Formula["valijson"].prefix}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
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
      assert_predicate share/"vulkan/explicit_layer.d/VkLayer_khronos_profiles.json", :exist?
    else
      ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"

      actual = shell_output("vulkaninfo")
      %w[VK_EXT_layer_settings VK_EXT_tooling_info].each do |expected|
        assert_match expected, actual
      end
    end
  end
end
