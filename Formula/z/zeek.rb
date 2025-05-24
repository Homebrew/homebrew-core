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
    sha256 arm64_sequoia: "4b2e266a93ebc3c7131d44d8724af6a74d6aba4b2b18a1e62cd1ed434f4a048f"
    sha256 arm64_sonoma:  "d19e2a76e79b428d9141b1caeac4a1e3ed732b2ac7e067b63a1db42223b3e5a6"
    sha256 arm64_ventura: "64d0138e17fd90e5f51fb5934b97d3ae1258869daba8984fecd95fdd0ab52c3b"
    sha256 sonoma:        "797f81b1ca21b4802625f07bf95ddaf3c85f6ecad9c8fe1585923b705fe92906"
    sha256 ventura:       "e7971b49366270d6af883976d4317036a1589b92d77571e060cdbd3240f8d16c"
    sha256 arm64_linux:   "5de10769a5d91741ec62578c5434c5576f52e17480a1c03421dfd539088dfc26"
    sha256 x86_64_linux:  "6b0791439a441817d22c7dd617ac01e7fa76930d09591efd888496a3bea267bb"
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

    # Benchmarks are not installed, but building them on Linux breaks in the
    # bundled google-benchmark dependency. Exclude the benchmark targets and
    # their library dependencies.
    #
    # TODO: Revisit this for the next release including
    # https://github.com/zeek/spicy/pull/2068. With that patch we should be
    # able to disable test and benchmark binaries with a CMake flag.
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
