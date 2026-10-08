class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v9.0.0/zeek-9.0.0.tar.gz"
  sha256 "1345474b3ea04c700f5421c30c7b81cf570056a16842abba03dfa5e2b6e3ed4e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "473fde6a5cce85127b85fc403a865654074f1be4c70008c1e642a8057b1aceb8"
    sha256 arm64_tahoe:       "4a0cbe8679e5f8d9cd0e0a4827f508f26df95ce521c4da0aaab6cc1f78f61974"
    sha256 arm64_sequoia:     "9ec0196cf822a9df676a8136d322bffd65cf871f62b5a50ad5e20cc5c4934eab"
    sha256 arm64_linux:       "d3d5d8e79ce06229ef36fb0708ed2bc23bca7db861f901af4daae39229e7d602"
    sha256 x86_64_linux:      "04716524bd3e6d40e8b938dfba9f6a3c654e173e83cedcb5ad49352a70792d67"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "libuv"
  depends_on "node@24"
  depends_on "openssl@4"
  depends_on "python@3.14"
  depends_on "zeromq"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https://github.com/Homebrew/homebrew-core/pull/74932
    inreplace "cmake_templates/zeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    # Avoid references to the Homebrew shims directory
    inreplace "auxil/spicy/hilti/toolchain/src/config.cc.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DBROKER_DISABLE_TESTS=on",
                    "-DINSTALL_AUX_TOOLS=on",
                    "-DINSTALL_ZEEKCTL=on",
                    "-DUSE_GEOIP=on",
                    "-DCARES_ROOT_DIR=#{formula_opt_prefix("c-ares")}",
                    "-DCARES_LIBRARIES=#{formula_opt_lib("c-ares")/shared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{formula_opt_lib("libmaxminddb")/shared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}",
                    "-DPYTHON_EXECUTABLE=#{python3}",
                    "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                    "-DZEEK_LOCAL_STATE_DIR=#{var}",
                    "-DDISABLE_JAVASCRIPT=off",
                    "-DNODEJS_ROOT_DIR=#{formula_opt_prefix("node@24")}",
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
