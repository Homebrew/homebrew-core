class VulkanProfiles < Formula
  include Language::Python::Virtualenv

  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/v1.3.278.tar.gz"
  sha256 "c6ed0f4c9ac536afad0cf302d34c064191deb6b9a8dc52718b4fa83a17897574"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eec52b47eaeced54cd5ae3ba5bf6a2c76d28484ce45e8d17baae37e877f61738"
    sha256 cellar: :any,                 arm64_ventura:  "5e9d95cd32f1d072e5186a470336c87b46e7b776255b27d6a9f9699b2b1eefb1"
    sha256 cellar: :any,                 arm64_monterey: "a557b3b02131ac912235617851da869eabdfc2b337f8b149ccd9450320d350a4"
    sha256 cellar: :any,                 sonoma:         "1a05ccab79adc95d2f685edb8a6937f6e28e1f5f86925458c678b91f23cd71e2"
    sha256 cellar: :any,                 ventura:        "2345efdbab29565e36c435d4de7585b5cc094243b666e962eebb267be56c1f05"
    sha256 cellar: :any,                 monterey:       "cd63fcd032fe91cb00bc8a4217cd4eedf052befe290ecd29574d476a14229c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e5a6bc1b7416bbbe12d681af673d7a844614b6a7a7fcb2b870fd65f8e30ee36"
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
