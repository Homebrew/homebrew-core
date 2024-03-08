class VulkanProfiles < Formula
  include Language::Python::Virtualenv

  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/v1.3.278.tar.gz"
  sha256 "c6ed0f4c9ac536afad0cf302d34c064191deb6b9a8dc52718b4fa83a17897574"
  license "Apache-2.0"
  revision 2
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d0cbdbe8da114a0ec9359db75e71ecfb1aef01a0cad45dd6d3227fa2911f0a0"
    sha256 cellar: :any,                 arm64_ventura:  "e44d7d44bc50b675f1e824c6758b06702bf4391f0cc37080c4b0e73b71100a62"
    sha256 cellar: :any,                 arm64_monterey: "f78f938eddd295bfa97c5c7a7fb4745a9681bd75386499dbfe79e6a7cc2b67a8"
    sha256 cellar: :any,                 sonoma:         "8350cb58b9cded666703eda63967955f3f078d9e3f80e55abc031bac1acb6ba0"
    sha256 cellar: :any,                 ventura:        "fd93f63d1a94c15639404804726745f007f048b41aa7e99c2fe17538910404aa"
    sha256 cellar: :any,                 monterey:       "fcda357165957a53306362d5e3f56cd365a34da9646ac7affa1b5103b4e994de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a10f96542a1dfb12a956a2a095d593250a247ddfa8254f58acd5f6e6843bb5"
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

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  def install
    venv = virtualenv_create libexec/"venv" # temporary
    venv.pip_install resource("jsonschema")

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

    rm_r libexec/"venv" # cleanup
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
