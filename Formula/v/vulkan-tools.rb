class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags/v1.3.268.tar.gz"
  sha256 "07b08b45812da1e82921ac707076558ec9b2f6f00eefefb69b911a1ba0715294"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4d41df7875f155c4fdadc3345f49901772efcb8d70424fe389f6a4c856126af"
    sha256 cellar: :any,                 arm64_ventura:  "d4cac3776598e19391ed199f8bdfc4de6c630af8e8c6fe4a962631996fa2ea04"
    sha256 cellar: :any,                 arm64_monterey: "940fe5d5f84beeb96219bead4454a8bdfcace6505f1d4d0d5ad4354fe0371507"
    sha256 cellar: :any,                 sonoma:         "d9ad23d802ddd301ff8116d979023e5807e8d5ad585bd9078265d065742e5246"
    sha256 cellar: :any,                 ventura:        "ca30603a36c46a092a240c162bdd664c9e2d0d2a8aad5b54655ef1cba3339dcd"
    sha256 cellar: :any,                 monterey:       "80b6af96aa3a7ee0aa0a56992bdacfc519f7cc9f2137835d0c649a3835300e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e8ab6083445030ee7036adc642dded10bccff35fccbceb18313ac5a222507d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
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
      "-DTOOLS_CODEGEN=ON", # custom codegen
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
