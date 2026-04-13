class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  # NOTE: Do not report issues with dependencies upstream as they only support
  # vendored dependencies, see https://github.com/wolfpld/tracy/issues/1079
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "d4efc50ebcb0bfcfdbba148995aeb75044c0d80f5d91223aebfaa8fa9e563d2b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6ca03823befeec20af1c9f3ee4117560d64d94b371d59c1617a8e00ebfb8353"
    sha256 cellar: :any,                 arm64_sequoia: "dcc660c342ecff72fe7f7a596323e609283c45922789d800ecef66c5455ea57b"
    sha256 cellar: :any,                 arm64_sonoma:  "19d370d5bc621409f2cb0213a70cd03802ce75dcd9ac28263bb366c58fad0085"
    sha256 cellar: :any,                 sonoma:        "350b91756e80530a10096160624ba921bd13426660e51839759b360509a891f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d829d6d75d94b266bd79a25887ba6a2eb910d378bb836fc938e2324b32f5ac3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7cdff0be4cca4002493400ca693c0638ea51957a556555a32f4df5bbb25b3bc"
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
