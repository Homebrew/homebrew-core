class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v9.0.1/zeek-9.0.1.tar.gz"
  sha256 "fbee2eb5ee6ebd64ef0db830fbb9fa1d702d58807643c719e8338a59329197f2"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "cc662bcfc658d14a0dd9675f10f597ad97f29803af0454031629d83aebdbc355"
    sha256 arm64_tahoe:       "cdd1fc59cc98264b8ec62d7522b0f3d83d76e06c097f1a51074a9077d3696566"
    sha256 arm64_sequoia:     "78c0c98cf7f0c3fd35b0070a99f433f8b1a402a773361153a2167947f6372dc6"
    sha256 arm64_linux:       "c44f00d76f9dfec1a0971dad34bbbd27a5bb4bc69adc5d40850a32b31580c7b9"
    sha256 x86_64_linux:      "a8d5be633746e3b7951b2bfa1021b7304179afe5087febf60cb877b136228f4e"
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
