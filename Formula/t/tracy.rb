class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://tracy.nereid.pl/"
  # NOTE: Do not report issues with dependencies upstream as they only support
  # vendored dependencies, see https://github.com/wolfpld/tracy/issues/1079
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "a932cf2a90adbf63f87b449fa4374a52f18a36c4a3858d4d69d3e75d62fa5f6a"
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
  # TODO: depends_on "md4c" once a release ships MD_FLAG_ADMONITIONS/FOOTNOTES
  depends_on "pugixml"
  depends_on "tidy-html5"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "glfw"
    # Linux vendors a newer NFD (see the `nfd` resource) for Wayland support
    depends_on "nativefiledialog-extended"
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "dbus"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "tbb"
    depends_on "wayland"

    # The profiler's Wayland backend needs NFD_SetWaylandDisplay, which postdates
    # nativefiledialog-extended 1.3.0. Vendor upstream's pinned commit until the
    # formula ships Wayland support.
    # TODO: add Wayland support to `nativefiledialog-extended` and drop this
    resource "nfd" do
      url "https://github.com/btzy/nativefiledialog-extended/archive/3cd252a8f7ca32419b1ca235c2990ba6a0ecba7c.tar.gz"
      version "1.3.0-g3cd252a"
      sha256 "3ea216a6f7cac2fefbd7dc1ce1deebf623a7f7d3022ee1d00277faccf2abd634"
    end
  end

  resource "capstone" do
    url "https://github.com/capstone-engine/capstone/releases/download/6.0.0-Alpha10/capstone-6.0.0-Alpha10.tar.xz"
    sha256 "3eabbad2c6e6b6904c78c72110527e5c560a245421fcc2dfbb135aa292a95e94"
  end

  resource "PPQSort" do
    url "https://github.com/GabTux/PPQSort/archive/refs/tags/v1.0.6.tar.gz"
    sha256 "12d9c05363fa3d36f4916a78f1c7e237748dfe111ef44b8b7a7ca0f3edad44da"
  end

  # Upstream pins an unreleased md4c commit for MD_FLAG_ADMONITIONS/FOOTNOTES,
  # which no md4c release (including brew's) provides yet
  resource "md4c" do
    url "https://github.com/mity/md4c/archive/65c6c9d72cebd9a731aaa5597414ce04d9ea5de3.tar.gz"
    version "0.5.3-77-g65c6c9d"
    sha256 "e69592e2cea567fefb06b22013297f51a27197b1507e36a4896b8376c040a808"
  end

  resource "usearch" do
    url "https://github.com/unum-cloud/USearch.git",
        tag:      "v2.26.0",
        revision: "cc23bbaf21ef52313c5a495adbc40cbd733cdcfb"
  end

  def install
    staging_prefix = buildpath/"brew"
    ENV.prepend_path "CMAKE_PREFIX_PATH", staging_prefix
    ENV["CPM_USE_LOCAL_PACKAGES"] = "ON"
    ENV["CPM_SOURCE_CACHE"] = buildpath/"cpm-cache"

    # Upstream only allows vendored deps so add some workarounds to use brew formulae instead
    inreplace "cmake/server.cmake", " libzstd ", " zstd::libzstd_shared "
    inreplace "cmake/vendor.cmake", /NAME json$/, "NAME nlohmann_json"

    # Upstream requests nfd without a version, so CPM calls `find_package(nfd "")`,
    # which the nfd config rejects; pin the version so the brew formula is reused
    nfd_version = Formula["nativefiledialog-extended"].version
    inreplace "cmake/vendor.cmake", /(NAME nfd)$/, "\\1\n            VERSION #{nfd_version}"

    # Workaround to bypass upstream vendoring tidy-html5 by adding a find module
    (staging_prefix/"Findtidy.cmake").write <<~CMAKE
      find_package(PkgConfig REQUIRED)
      pkg_check_modules(tidy REQUIRED IMPORTED_TARGET tidy)
      add_library(tidy-static ALIAS PkgConfig::tidy)
      include(FindPackageHandleStandardArgs)
      find_package_handle_standard_args(tidy REQUIRED_VARS tidy_LIBRARIES VERSION_VAR tidy_VERSION)
    CMAKE

    # md4c ships no CMake version file, so CPM's versioned `find_package` misses the
    # staged copy and would fetch online; a pkg-config find module reuses the staged build
    (staging_prefix/"Findmd4c.cmake").write <<~CMAKE
      find_package(PkgConfig REQUIRED)
      pkg_check_modules(md4c REQUIRED IMPORTED_TARGET md4c)
      if(NOT TARGET md4c::md4c)
        add_library(md4c::md4c ALIAS PkgConfig::md4c)
      endif()
      include(FindPackageHandleStandardArgs)
      find_package_handle_standard_args(md4c REQUIRED_VARS md4c_LIBRARIES VERSION_VAR md4c_VERSION)
    CMAKE

    # The profiler links md4c's raw CPM target and pulls headers from its source tree;
    # retarget both at the brew-style staged build so no online fetch is needed
    inreplace "profiler/CMakeLists.txt", /^    md4c$/, "    md4c::md4c"
    inreplace "profiler/CMakeLists.txt", %r{\$\{md4c_SOURCE_DIR\}/src}, staging_prefix/"include"

    odie "Try replacing capstone resource with dependency!" if Formula["capstone"].stable.version >= "6.0.0"
    resource("capstone").stage do
      # https://github.com/wolfpld/tracy/blob/v0.14.0/cmake/vendor.cmake#L40-L62
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

    resource("md4c").stage do
      system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=OFF",
             *std_cmake_args(install_prefix: staging_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
    ENV.prepend_path "PKG_CONFIG_PATH", staging_prefix/"lib/pkgconfig"

    # Build the Wayland-capable NFD into the staging prefix so it precedes the
    # older `nativefiledialog-extended` formula in the CPM `find_package` search.
    if OS.linux?
      resource("nfd").stage do
        # NFD's Wayland build expects the xdg-foreign protocol from its git
        # submodule; source it from the `wayland-protocols` formula instead.
        proto = "unstable/xdg-foreign/xdg-foreign-unstable-v1.xml"
        (buildpath/"nfd-3ps/unstable/xdg-foreign").install \
          Formula["wayland-protocols"].opt_share/"wayland-protocols/#{proto}"
        inreplace "src/CMakeLists.txt",
                  "${CMAKE_CURRENT_SOURCE_DIR}/../3ps/wayland-protocols/#{proto}",
                  "#{buildpath}/nfd-3ps/#{proto}"
        system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=OFF",
               "-DNFD_PORTAL=ON", "-DNFD_WAYLAND=ON", *std_cmake_args(install_prefix: staging_prefix)
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
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
    end

    args = %w[CAPSTONE GLFW FREETYPE LIBCURL PUGIXML].map { |arg| "-DDOWNLOAD_#{arg}=OFF" }
    args << "-DCMAKE_MODULE_PATH=#{staging_prefix}"
    # upstream injects a bare `ccache` compile launcher that is not on the sandboxed build PATH
    args << "-DNO_CCACHE=ON"

    buildpath.each_child do |child|
      next unless child.directory?
      next unless (child/"CMakeLists.txt").exist?
      # `monitor` is a Linux-only perf_event tool that upstream never builds in CI
      next if %w[python test monitor].include?(child.basename.to_s)

      # Workaround to link to shared nativefiledialog-extended. Upstream only supports vendored libs
      extra_args = ["-DCMAKE_EXE_LINKER_FLAGS=-lobjc"] if OS.mac? && child.basename.to_s == "profiler"

      system "cmake", "-S", child, "-B", child/"build", *args, *extra_args, *std_cmake_args
      system "cmake", "--build", child/"build"
      bin.install child.glob("build/tracy-*").select(&:executable?)
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", "-DNO_CCACHE=ON", *std_cmake_args
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
