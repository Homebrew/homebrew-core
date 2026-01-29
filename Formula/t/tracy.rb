class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  # NOTE: Do not report issues with dependencies upstream as they only support
  # vendored dependencies, see https://github.com/wolfpld/tracy/issues/1079
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "d4efc50ebcb0bfcfdbba148995aeb75044c0d80f5d91223aebfaa8fa9e563d2b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5612309d34ac9c0a34ab536a0259a85039825959af74b5d1af40a38a79e78898"
    sha256 cellar: :any,                 arm64_sequoia:  "ef5601dccb812f86784c050ffc090b003b18dae3f1a8e38aa2994a43628f6079"
    sha256 cellar: :any,                 arm64_sonoma:   "d6f150dd66767e47837006f661a3c36ed7cd7ad21dfe76a7c1ba8aff1820a924"
    sha256 cellar: :any,                 arm64_ventura:  "2b2b2517cdf72b57face88cc1dbf6083bfd2a2b2271e857825bc7d012fd2bf43"
    sha256 cellar: :any,                 arm64_monterey: "27320ae60ea734c462bbfcd54fbee3444eed1de85b80315c1814850d043b229e"
    sha256 cellar: :any,                 sonoma:         "4f862af547f74f1859b5e717cd7368a6394b170db1f68ead37b23ddd5a1e1cfb"
    sha256 cellar: :any,                 ventura:        "b32e96ee1c8c76f0064509f450da12f54b2860c007a3651288e6fd2bb0d7cc0c"
    sha256 cellar: :any,                 monterey:       "1db13a28c85ccdd2ea30ca6f33b8a534b60610f513c3ae69ddc3d33e2ae8ab5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e42b03f16a1d0f0ccc344b0426a3ec779eeb3bf37dd9491847873b379693eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeef3daf639e9ed8491a9b7e0b11652809dd6d165410d9070fcf5f40f8883a85"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "aklomp-base64"
  # TODO: depends_on "capstone"
  depends_on "freetype"
  depends_on "md4c"
  depends_on "nativefiledialog-extended"
  depends_on "pugixml"
  depends_on "tidy-html5"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "glfw"
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "dbus"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "tbb"
    depends_on "wayland"
  end

  resource "capstone" do
    url "https://github.com/capstone-engine/capstone/releases/download/6.0.0-Alpha6/capstone-6.0.0-Alpha6.tar.xz"
    sha256 "8ad244c35508b28d6c0751e3610a25380f34ddd892c968212794ed6a90d8e3cb"
  end

  resource "PPQSort" do
    url "https://github.com/GabTux/PPQSort/archive/refs/tags/v1.0.6.tar.gz"
    sha256 "12d9c05363fa3d36f4916a78f1c7e237748dfe111ef44b8b7a7ca0f3edad44da"
  end

  resource "usearch" do
    url "https://github.com/unum-cloud/USearch.git",
        tag:      "v2.23.0",
        revision: "7306bb446be5f0f0c529ec8acdc57361cef8a8a7"
  end

  def install
    staging_prefix = buildpath/"brew"
    ENV.prepend_path "CMAKE_PREFIX_PATH", staging_prefix
    ENV["CPM_USE_LOCAL_PACKAGES"] = "ON"
    ENV["CPM_SOURCE_CACHE"] = buildpath/"cpm-cache"

    # Upstream only allows vendored deps so add some workarounds to use brew formulae instead
    inreplace "cmake/server.cmake", " libzstd ", " zstd::libzstd_shared "
    inreplace "cmake/vendor.cmake", /NAME json$/, "NAME nlohmann_json"

    # Workaround to bypass upstream vendoring tidy-html5 by adding a find module
    (staging_prefix/"Findtidy.cmake").write <<~CMAKE
      find_package(PkgConfig REQUIRED)
      pkg_check_modules(tidy REQUIRED IMPORTED_TARGET tidy)
      add_library(tidy-static ALIAS PkgConfig::tidy)
      include(FindPackageHandleStandardArgs)
      find_package_handle_standard_args(tidy REQUIRED_VARS tidy_LIBRARIES VERSION_VAR tidy_VERSION)
    CMAKE

    odie "Try replacing capstone resource with dependency!" if Formula["capstone"].stable.version >= "6.0.0"
    resource("capstone").stage do
      # https://github.com/wolfpld/tracy/blob/v0.13.1/cmake/vendor.cmake#L30-L53
      disable_archs = %w[
        ALPHA ARC HPPA LOONGARCH M680X M68K MIPS MOS65XX PPC SPARC SYSTEMZ
        XCORE TRICORE TMS320C64X M680X EVM WASM BPF RISCV SH XTENSA
      ]
      args = disable_archs.map { |arch| "-DCAPSTONE_#{arch}_SUPPORT=OFF" }
      args += %w[-DCAPSTONE_X86_ATT_DISABLE=ON -DCAPSTONE_BUILD_MACOS_THIN=ON]

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: staging_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("PPQSort").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: staging_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("usearch").stage do
      args = %w[
        -DUSEARCH_INSTALL=ON
        -DUSEARCH_BUILD_BENCH_CPP=OFF
        -DUSEARCH_BUILD_TEST_CPP=OFF
      ]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: staging_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      (staging_prefix/"fp16").install "fp16/include"
    end

    args = %w[CAPSTONE GLFW FREETYPE LIBCURL PUGIXML].map { |arg| "-DDOWNLOAD_#{arg}=OFF" }
    args << "-DCMAKE_MODULE_PATH=#{staging_prefix}"

    buildpath.each_child do |child|
      next unless child.directory?
      next unless (child/"CMakeLists.txt").exist?
      next if %w[python test].include?(child.basename.to_s)

      # Workaround to link to shared nativefiledialog-extended. Upstream only supports vendored libs
      extra_args = ["-DCMAKE_EXE_LINKER_FLAGS=-lobjc"] if OS.mac? && child.basename.to_s == "profiler"

      system "cmake", "-S", child, "-B", child/"build", *args, *extra_args, *std_cmake_args
      system "cmake", "--build", child/"build"
      bin.install child.glob("build/tracy-*").select(&:executable?)
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink "tracy-profiler" => "tracy"
  end

  test do
    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")

    port = free_port
    pid = spawn bin/"tracy", "-p", port.to_s
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
