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
    rebuild 2
    sha256 arm64_golden_gate: "aa92187411a053b0ffcce7756e8ccfde614f37ebdc70b7d5b9f0cdd7fb4963f2"
    sha256 arm64_tahoe:       "44d0f3e175d6d3f2da7264e0f588ac4c01448d755467785d7b08314acc26ff4d"
    sha256 arm64_sequoia:     "a7e7e6a04a8bdf0c40769c62a54651ed8258f90718703844a83d065a6602c950"
    sha256 arm64_linux:       "bbb11ee62a84aab554047f2e7c891af9eec5dea6b8fa21107412cd312e9ef851"
    sha256 x86_64_linux:      "b3543be14b78cc787af9eb54ec11b91129d7af7b373d890bcf2cd6c54cfdaec5"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "libuv"
  depends_on "node"
  depends_on "openssl@4"
  depends_on "python@3.15"
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

    args = %W[
      -DBROKER_DISABLE_TESTS=on
      -DINSTALL_AUX_TOOLS=on
      -DINSTALL_ZEEKCTL=on
      -DUSE_GEOIP=on
      -DCARES_ROOT_DIR=#{formula_opt_prefix("c-ares")}
      -DCARES_LIBRARIES=#{formula_opt_lib("c-ares")/shared_library("libcares")}
      -DLibMMDB_LIBRARY=#{formula_opt_lib("libmaxminddb")/shared_library("libmaxminddb")}
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
      -DPYTHON_EXECUTABLE=#{python3}
      -DZEEK_ETC_INSTALL_DIR=#{etc}
      -DZEEK_LOCAL_STATE_DIR=#{var}
      -DDISABLE_JAVASCRIPT=off
      -DNODEJS_ROOT_DIR=#{formula_opt_prefix("node")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
