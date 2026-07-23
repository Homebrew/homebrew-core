class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v8.2.1/zeek-8.2.1.tar.gz"
  sha256 "a8067c75cc89bef4b58019230434a90073671a7cabfcf7ac616ac872a40a2edd"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "5128ddbdb27d48fc6e2ffff1a33acb775cb1dfcd599f9c5381224a973eab9748"
    sha256 arm64_sequoia: "77ba8ee74e2a0b6ce33fff87bed1f3c96dfcd9c762b633d2e2407d70ab6690d6"
    sha256 arm64_sonoma:  "09270c8aff56b9fa76e3f9038d6788cb5c94ed6c4f443033287db2929f5f436b"
    sha256 sonoma:        "92599d74e6c49f43fa5265e0a32d412e02c8f6de939f0f376ee99e2a65b3cae7"
    sha256 arm64_linux:   "6d3437cf6651d4baaacb7a49e17cfb1d33dbf051c4f583e2d3f7f58ae46d4506"
    sha256 x86_64_linux:  "19e9879416817ad97c533f1284c49c0acb75dbbeaf06b507f8b9e1188f67167a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "libuv"
  depends_on "node@24"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "zeromq"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.14")}",
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
