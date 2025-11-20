class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "7ee96a046e5b39fc7a14ee9f24f583e5b1a6605c07bbb1dcd5430d5a274c34f1"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01e8ba7b73ff7955de21717d29ce432c60a146c75a3158bed60330d40f1bce4e"
    sha256 cellar: :any,                 arm64_sequoia: "c1e76678b0d75e433476d40b663247d6ad4f998f01daad8bc0017ea883e57ae0"
    sha256 cellar: :any,                 arm64_sonoma:  "525b848e0ee206d52751f8604bf17d67dbd8e7b2091069a03f3e6290bd50b8fc"
    sha256 cellar: :any,                 sonoma:        "7985cd12be7e5df54485adf807242b65a7f0eb639cf64471004ff89ba7679d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2daf5369e75a414af600883379c0971d94d941b4eb3abf8fb09cf59cdd419ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c57221568ff40fdef0164487f992b4f9a1db0f53794ee6b576b2af7dd208d1"
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
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
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

      actual = shell_output("vulkaninfo")
      %w[VK_EXT_layer_settings VK_EXT_tooling_info].each do |expected|
        assert_match expected, actual
      end
    end
  end
end
