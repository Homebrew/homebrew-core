class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v5.2.2",
      revision: "a6f825b81da389bb2deb1cf389dbd7e88efd4a1c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "98b8d8943f442221f05174c229f17672ef255160e4d12db2690dfeef2a1324a2"
    sha256 arm64_ventura:  "5b19a489563490138968960941d0a7d83fea696a36d744209ec4b46161d4e39f"
    sha256 arm64_monterey: "40de368557e8b27c93f99f956b0a8e88509d57babc96974fe6c416cc987904b1"
    sha256 sonoma:         "b45e9cb72cd6bfe052382566fb66d2f57022feec177a001e3f001fd747e59e59"
    sha256 ventura:        "dc38bec2698e550aef8519be5efe969cdf2683758ef85dd30963f06fe10c64c3"
    sha256 monterey:       "02642cbc88ff2b026e540e1864b3642956bd05e1869bb3cd6b266603732fdfb9"
    sha256 x86_64_linux:   "3d59a313bc94c48911256bc5e9b1ac2ed4ff7477b107ff63552b9b99c58d9d46"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on macos: :mojave
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    (buildpath/"auxil/c-ares").rmtree

    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https://github.com/Homebrew/homebrew-core/pull/74932
    inreplace "zeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    # Avoid references to the Homebrew shims directory
    inreplace "auxil/spicy/spicy/hilti/toolchain/src/config.cc.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DBROKER_DISABLE_TESTS=on",
                    "-DINSTALL_AUX_TOOLS=on",
                    "-DINSTALL_ZEEKCTL=on",
                    "-DUSE_GEOIP=on",
                    "-DCARES_ROOT_DIR=#{Formula["c-ares"].opt_prefix}",
                    "-DCARES_LIBRARIES=#{Formula["c-ares"].opt_lib/shared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{Formula["libmaxminddb"].opt_lib/shared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.12")}",
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
    assert_predicate testpath/"conn.log", :exist?
    refute_predicate testpath/"conn.log", :empty?
    assert_predicate testpath/"http.log", :exist?
    refute_predicate testpath/"http.log", :empty?
    # For bottling MacOS SDK paths must not be part of the public include directories, see zeek/zeek#1468.
    refute_includes shell_output("#{bin}/zeek-config --include_dir").chomp, "MacOSX"
  end
end
