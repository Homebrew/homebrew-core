class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags/v1.3.250.tar.gz"
  sha256 "a1cd4f7d8d58bec26efb1e5ea73f82dcf36a9662d55401b81a783071b211a35a"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35640ca7a274e095c7ba6619010b416755709b0b6ca898fac734018d664cafd3"
    sha256 cellar: :any,                 arm64_monterey: "55ba17c63cb698844c4c578fff44c5a1270aba177a86b34e8b962dd201fb71a1"
    sha256 cellar: :any,                 arm64_big_sur:  "1d193b892373f39237cd8d8532e83114de1f7c616418934e8168e1eedc478fb9"
    sha256 cellar: :any,                 ventura:        "86b90ae78d2ee4fdac851385389e57c3c09c95980473d3d54bea514390d96f04"
    sha256 cellar: :any,                 monterey:       "bd529be54e7e4f0789b1004ae2dfbd5a18540438ca241bf94f2e8ea05cede9c7"
    sha256 cellar: :any,                 big_sur:        "e74eff0f4bf7e15e5dee2bf5aa47a58272a79664bcd576d7c13f06454c663b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d9e8cb757c28c660399da31e0bd789346b01c8c0d9d29b2ffc67b8b36f5e70"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  def install
    if OS.mac?
      # account for using already-built MoltenVK instead of the source repo
      inreplace "mac_common.cmake",
                "${MOLTENVK_DIR}/MoltenVK/icd/MoltenVK_icd.json",
                "${MOLTENVK_DIR}/share/vulkan/icd.d/MoltenVK_icd.json"
      inreplace buildpath.glob("*/macOS/*/*.cmake") do |s|
        s.gsub! "${MOLTENVK_DIR}/MoltenVK/include",
                "${MOLTENVK_DIR}/include"
        s.gsub! "${MOLTENVK_DIR}/MoltenVK/dylib/macOS/libMoltenVK.dylib",
                "${MOLTENVK_DIR}/lib/libMoltenVK.dylib"
      end
    end

    args = [
      "-DBUILD_ICD=ON",
      "-DBUILD_CUBE=ON",
      "-DBUILD_VULKANINFO=ON",
      "-DINSTALL_ICD=OFF", # we will manually place it in a nonconflicting location
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].opt_prefix}",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
      "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].opt_prefix}",
    ]
    args += if OS.mac?
      ["-DMOLTENVK_REPO_ROOT=#{Formula["molten-vk"].opt_prefix}"]
    else
      [
        "-DBUILD_WSI_DIRECTFB_SUPPORT=OFF",
        "-DBUILD_WSI_WAYLAND_SUPPORT=ON",
        "-DBUILD_WSI_XCB_SUPPORT=ON",
        "-DBUILD_WSI_XLIB_SUPPORT=ON",
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "VulkanTools_generated_source"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (lib/"mock_icd").install (buildpath/"build/icd/VkICD_mock_icd.json").realpath,
                             shared_library("build/icd/libVkICD_mock_icd")

    return unless OS.mac?

    targets = [
      Formula["molten-vk"].opt_lib/shared_library("libMoltenVK"),
      Formula["vulkan-loader"].opt_lib/shared_library("libvulkan", Formula["vulkan-loader"].version),
    ]
    prefix.glob("cube/*.app/Contents/Frameworks").each do |framework_dir|
      ln_sf targets, framework_dir, verbose: true
    end

    bin.install prefix/"vulkaninfo/vulkaninfo"
    (bin/"vkcube").write_env_script "/usr/bin/open", "-a #{prefix}/cube/vkcube.app", {}
    (bin/"vkcubepp").write_env_script "/usr/bin/open", "-a #{prefix}/cube/vkcubepp.app", {}
  end

  def caveats
    <<~EOS
      The mock ICD files have been installed in
        #{opt_lib}/mock_icd
      You can use them with the Vulkan Loader by setting
        export VK_ICD_FILENAMES=#{opt_lib}/mock_icd/VkICD_mock_icd.json
    EOS
  end

  test do
    ENV["VK_ICD_FILENAMES"] = lib/"mock_icd/VkICD_mock_icd.json"
    system bin/"vulkaninfo", "--summary"
  end
end
