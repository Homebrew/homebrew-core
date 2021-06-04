class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v4.0.2",
      revision: "b372622610a4d9fb96e94d8108f282a7f6865f86"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 arm64_big_sur: "ba5ee9e2acf7dc41da3addadbdf3c2fdb201d012b2d45cb6d414cdf5bb78c962"
    sha256 big_sur:       "3caa4e22a0983ce76fef62b2e0d2665691fd71a724192031eb0fc6c8c8c88555"
    sha256 catalina:      "648345b2bb189c2609e8610e8f0a0eaea034cfdf88d078d228cb3d1934ac1c64"
    sha256 mojave:        "2be006af7ccb9f98dfaf05915a93443e4f7f1f73baa0a26d85d29c70188bf131"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "libmaxminddb"
  depends_on macos: :mojave
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "flex"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  def install
    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https://github.com/corelight/zeek-community-id/issues/15
    # Remove the `:` in each `inreplace` when this lands in a release:
    # https://github.com/zeek/zeek/commit/ca725c1f9b96c8eb33885a29d24eefddf28e16ab
    inreplace "zeek-config.in" do |s|
      s.gsub! ":@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! ":@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DBROKER_DISABLE_TESTS=on",
                      "-DBUILD_SHARED_LIBS=on",
                      "-DINSTALL_AUX_TOOLS=on",
                      "-DINSTALL_ZEEKCTL=on",
                      "-DUSE_GEOIP=on",
                      "-DCAF_ROOT=#{Formula["caf"].opt_prefix}",
                      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                      "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                      "-DZEEK_LOCAL_STATE_DIR=#{var}"
      system "make", "install"
    end
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
