class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v7.2.2/zeek-7.2.2.tar.gz"
  sha256 "2b1df248f94199a1684e1c460d64cf1c5e49d7471c2b562f942ac5fbe9805893"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "8cefa76cf846d5988dce878225bff84fac29f2bccc4d37317b635a6019a9a76c"
    sha256 arm64_sonoma:  "2b2576853fc45189373fb6acb6092975e3052cd06ae82828e676771307c7a369"
    sha256 arm64_ventura: "89d2a18a83e55a9988fe7ebe2c232364b49e049da55c19a7e6af474288103118"
    sha256 sonoma:        "85c646902644d17a78936d327e2cfa9325bf72a2f561be279324c0dfbe5497fb"
    sha256 ventura:       "d9678401857ba7f761e96f69d0cbf927f7e4b2327971eafd87401fccda22b995"
    sha256 arm64_linux:   "80a5d6d59d74dd824eb4b8921bbda82c8ecd3860fe17d3b9392fb574f8002270"
    sha256 x86_64_linux:  "a876b202a65f3774518765fef945147798d0221b70c9affacae0655b4fbc425f"
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

    if build.stable?
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
