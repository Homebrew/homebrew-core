class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "617e91b396ac771869d62cd131f05dcc0b82d038744dab7f575bcf213852f8bf"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "e079b74dc2567dd9caf79a1f89330785766bee451674c4e48caac0fd3b77882b"
    sha256                               arm64_sequoia: "921563dd293ce0efcfae733634ad8fef0730d502689cfe204852b5e67e81920a"
    sha256                               arm64_sonoma:  "246ce100577c4fe6d65ea969488b5011557cbadcfec3562cd2b22eca40d6fb98"
    sha256 cellar: :any,                 sonoma:        "df9cf294d5a387539ca41254529dcfc1eb24019ea48a5c443ed2e858e29e6066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e4db1b7ae9f312bcaca4151c1809f104d33072513c2576f3342a142184f5919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f980af2c3cb0c031f3ad5b256f2f31b5e159d8a78b69f3d80d76e46b068caf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build # for ibtool
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
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
      inreplace "cube/CMakeLists.txt",
                "${MOLTENVK_DIR}/MoltenVK/icd/MoltenVK_icd.json",
                "${MOLTENVK_DIR}/etc/vulkan/icd.d/MoltenVK_icd.json"
      inreplace buildpath.glob("*/macOS/*/CMakeLists.txt"),
                "${MOLTENVK_DIR}/Package/Release/MoltenVK/dynamic/dylib/macOS/libMoltenVK.dylib",
                "${MOLTENVK_DIR}/lib/libMoltenVK.dylib"
    end

    args = [
      "-DBUILD_ICD=ON",
      "-DBUILD_CUBE=ON",
      "-DBUILD_VULKANINFO=ON",
      "-DINSTALL_ICD=OFF", # we will manually place it in a nonconflicting location
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].opt_prefix}",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
      "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].opt_prefix}",
      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
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
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (lib/"mock_icd").install (buildpath/"build/icd/VkICD_mock_icd.json").realpath,
                             shared_library("build/icd/libVkICD_mock_icd")

    return unless OS.mac?

    targets = [
      Formula["molten-vk"].opt_lib/shared_library("libMoltenVK"),
      Formula["vulkan-loader"].opt_lib/shared_library("libvulkan", Formula["vulkan-loader"].version.to_s),
    ]
    prefix.glob("cube/*.app/Contents/Frameworks").each do |framework_dir|
      ln_sf targets, framework_dir, verbose: true
    end

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
    with_env(VK_ICD_FILENAMES: lib/"mock_icd/VkICD_mock_icd.json") do
      assert_match "Vulkan Mock Device", shell_output("#{bin}/vulkaninfo --summary")
    end

    return if !OS.mac? || (Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"])

    with_env(XDG_DATA_DIRS: testpath) do
      assert_match "DRIVER_ID_MOLTENVK", shell_output("#{bin}/vulkaninfo --summary")
    end
  end
end
