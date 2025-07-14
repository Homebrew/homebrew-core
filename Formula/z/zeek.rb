class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v7.2.1/zeek-7.2.1.tar.gz"
  sha256 "9dbab6e531aafc7b9b4df032b31b951d4df8c69dc0909a7cc811c1db4165502d"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "6b9d73f5e6a6d555f41742983f2bbc1ffec5db7584e7b9676c6d8596348062bf"
    sha256 arm64_sonoma:  "ca30fa586b51db8f92a39c54d40edb011dc98dbfc6ee9895eae972cd892c33a3"
    sha256 arm64_ventura: "8c4424c2caa16d2e9c93884a9e4f37a66df52a69d6c631fd97caa825f9a765cd"
    sha256 sonoma:        "1b061c0b27d2fdf90118d4b0c39a4c6aa38ab5f14ae0768385a39f2f5996c454"
    sha256 ventura:       "0739433183b73bf09561e3f90da4b87c4ab5dafabe615bb169026feb2928440d"
    sha256 arm64_linux:   "a180c1087293b43eec540f63aea314356d9406c51352fb4a93c7b4616313f8ca"
    sha256 x86_64_linux:  "40b61706e5d1a6c65ac774635e777a11f2eec6a0bb409465576359420a9e5c99"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on macos: :mojave
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https://github.com/Homebrew/homebrew-core/pull/74932
    inreplace "cmake_templates/zeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    # Avoid references to the Homebrew shims directory
    inreplace "auxil/spicy/hilti/toolchain/src/config.cc.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    unless build.head?
      # Benchmarks are not installed, but building them on Linux breaks in the
      # bundled google-benchmark dependency. Exclude the benchmark targets and
      # their library dependencies.
      #
      # This is fixed on Zeek's `master` branch and will be available with
      # zeek-8.0. There there is a CMake variable `SPICY_ENABLE_TESTS` which
      # defaults to `OFF`.
      inreplace "auxil/spicy/hilti/runtime/CMakeLists.txt",
        "add_executable(hilti-rt-fiber-benchmark src/benchmarks/fiber.cc)",
        "add_executable(hilti-rt-fiber-benchmark EXCLUDE_FROM_ALL src/benchmarks/fiber.cc)"
      inreplace "auxil/spicy/spicy/runtime/tests/benchmarks/CMakeLists.txt",
        "add_executable(spicy-rt-parsing-benchmark parsing.cc ${_generated_sources})",
        "add_executable(spicy-rt-parsing-benchmark EXCLUDE_FROM_ALL parsing.cc ${_generated_sources})"
      inreplace "auxil/spicy/3rdparty/justrx/src/tests/CMakeLists.txt",
        "add_executable(bench benchmark.cc)",
        "add_executable(bench EXCLUDE_FROM_ALL benchmark.cc)"
      (buildpath/"auxil/spicy/3rdparty/CMakeLists.txt").append_lines <<~CMAKE
        set_target_properties(benchmark PROPERTIES EXCLUDE_FROM_ALL ON)
        set_target_properties(benchmark_main PROPERTIES EXCLUDE_FROM_ALL ON)
      CMAKE
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DBROKER_DISABLE_TESTS=on",
                    "-DINSTALL_AUX_TOOLS=on",
                    "-DINSTALL_ZEEKCTL=on",
                    "-DUSE_GEOIP=on",
                    "-DCARES_ROOT_DIR=#{Formula["c-ares"].opt_prefix}",
                    "-DCARES_LIBRARIES=#{Formula["c-ares"].opt_lib/shared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{Formula["libmaxminddb"].opt_lib/shared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.13")}",
                    "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                    "-DZEEK_LOCAL_STATE_DIR=#{var}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/zeek --version")
    assert_match "ARP packet analyzer", shell_output("#{bin}/zeek --print-plugins")
    system bin/"zeek", "-C", "-r", test_fixtures("test.pcap")
    assert_path_exists testpath/"conn.log"
    refute_empty (testpath/"conn.log").read
    assert_path_exists testpath/"http.log"
    refute_empty (testpath/"http.log").read
    # For bottling MacOS SDK paths must not be part of the public include directories, see zeek/zeek#1468.
    refute_includes shell_output("#{bin}/zeek-config --include_dir").chomp, "MacOSX"
  end
end
