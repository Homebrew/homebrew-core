class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://tracy.nereid.pl/"
  # NOTE: Do not report issues with dependencies upstream as they only support
  # vendored dependencies, see https://github.com/wolfpld/tracy/issues/1079
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "bf4af567e9c7524d07f3caa745fad02fb33bd5694f11910750382d1efbb251c1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "86c886dd9aa1df9ec1e2770ec914c88fe19545dd7554f6b2d29a3f42fe1a203c"
    sha256 cellar: :any, arm64_tahoe:       "1ddc9848cebb0aa9525840066403eab154414756929c3cb2601ca4e6566c9cc6"
    sha256 cellar: :any, arm64_sequoia:     "b68140824409c1ddfac310712044ce1ea0c560cfd4f35ec2fe007ce6a685305f"
    sha256 cellar: :any, arm64_linux:       "96f39f7f1dc7916340ba7635ab28443ecbec189fb2307fa4473644aa1eab82c4"
    sha256 cellar: :any, x86_64_linux:      "608694a84e1dfb3099d3b55d1f4a9d4f4f87eaee44eecef5b174c9919de9fd7d"
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

  conflicts_with "tracy-genomics", because: "both install `tracy` binaries"

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
    inreplace "cmake/vendor.cmake", /NAME nfd$/,
              "NAME nfd\n            VERSION #{Formula["nativefiledialog-extended"].version}"

    # md4c does not install a CMake package version file, so use pkg-config.
    (staging_prefix/"Findmd4c.cmake").write <<~CMAKE
      find_package(PkgConfig REQUIRED)
      pkg_check_modules(md4c REQUIRED IMPORTED_TARGET md4c)
      add_library(md4c ALIAS PkgConfig::md4c)
      include(FindPackageHandleStandardArgs)
      find_package_handle_standard_args(md4c REQUIRED_VARS md4c_LIBRARIES VERSION_VAR md4c_VERSION)
    CMAKE

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
    end

    args = %w[CAPSTONE GLFW FREETYPE LIBCURL PUGIXML].map { |arg| "-DDOWNLOAD_#{arg}=OFF" }
    args << "-DCMAKE_MODULE_PATH=#{staging_prefix}"
    args << "-DNO_CCACHE=ON"

    # `monitor` uses Linux `perf_event` APIs and is unguarded upstream
    skip_dirs = %w[python test]
    skip_dirs << "monitor" if OS.mac?

    buildpath.each_child do |child|
      next unless child.directory?
      next unless (child/"CMakeLists.txt").exist?
      next if skip_dirs.include?(child.basename.to_s)

      # Workaround to link to shared nativefiledialog-extended. Upstream only supports vendored libs
      extra_args = ["-DCMAKE_EXE_LINKER_FLAGS=-lobjc"] if OS.mac? && child.basename.to_s == "profiler"

      system "cmake", "-S", child, "-B", child/"build", *args, *extra_args, *std_cmake_args
      system "cmake", "--build", child/"build"
      bin.install child.glob("build/tracy-*").select(&:executable?)
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", "-DTRACY_ENABLE=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink "tracy-profiler" => "tracy"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tracy/Tracy.hpp>
      #include <iostream>
      int main() {
        ZoneScoped;
        FrameMark;
        std::cout << "instrumented client" << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-DTRACY_ENABLE", "-DTRACY_IMPORTS", "-I#{include}/tracy",
           "-L#{lib}", "-lTracyClient", "-pthread", "-o", "test"
    assert_equal "instrumented client", shell_output("./test").strip

    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")
  end
end
