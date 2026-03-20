class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v8.1.1/zeek-8.1.1.tar.gz"
  sha256 "b5f9edd4a10412426e6414d2f851ba42ce1fa94b59ccbad4238519adae6fc065"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "444fa891df006c4513561272d00eb7c7a07e98c6504637e8fe265be18c5a9a22"
    sha256 arm64_sequoia: "33189a6424cad59aa69fc9f15327d8c742761015ee15e34bbb475a404933e449"
    sha256 arm64_sonoma:  "834f4180afcbbd36d0b5bc60e77f0dab14c10a5bc66cc514a4e463238733a5e1"
    sha256 sonoma:        "6b331685a5819570105c8c5d37c68cfe4840ccf6b8b70d4d2f7a005e11035950"
    sha256 arm64_linux:   "0b99912e2ce0c49354f6af8010d29cf35238304c70bebb81b6a0db296af4011c"
    sha256 x86_64_linux:  "20566003c46777f2c2b6c1eaef8630bd6034f20e3350e99625c6ac82a90defde"
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
                    "-DCARES_ROOT_DIR=#{Formula["c-ares"].opt_prefix}",
                    "-DCARES_LIBRARIES=#{Formula["c-ares"].opt_lib/shared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{Formula["libmaxminddb"].opt_lib/shared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.14")}",
                    "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                    "-DZEEK_LOCAL_STATE_DIR=#{var}",
                    "-DDISABLE_JAVASCRIPT=off",
                    "-DNODEJS_ROOT_DIR=#{Formula["node@24"].opt_prefix}",
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
