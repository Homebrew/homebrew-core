class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.3.268.tar.gz"
  sha256 "2e6704eb2609fe2f0f79fdd016b7b403ac6466391d4e63879438962077261140"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b2faeae2112793e49e0dff23705d210b9758ca935d1a345895fd34cc58e6862"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5643bc8bfedf740f2c8565e6f28e38e06a5766ec75b8bff87f9f8531ad876a69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1a6ab45fd460528a6579567aa8717110e84c21c9c907265cc7e29e5570f4c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "475053e934ed60dea58cb02b36d1b04390749e9476e4a35b2bf3c56d44aeae58"
    sha256 cellar: :any_skip_relocation, ventura:        "9d94eecae0f22c5b450b895072cf03bdf5732751df1a63efa47a19e7557764de"
    sha256 cellar: :any_skip_relocation, monterey:       "f20028cfa2a5fa3f975f2e9b40ee425c3ad2ac085f6969b86d7e6321addc802c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e3b3fdc68b8208790323c32a704bda2139f3b9b23e193f8cdb9864adb09da8"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-utility-libraries"

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#43
  resource "SPIRV-Headers" do
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "d790ced752b5bfc06b6988baadef6eb2d16bdf96"
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#L57
  resource "SPIRV-Tools" do
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "847715d6c65200987c079fb13ca7925760faec23"
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

    expected = <<~EOS
      Instance Layers: count = 1
      --------------------------
      VK_LAYER_KHRONOS_validation Khronos Validation Layer #{version}  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match expected, actual
  end
end
