class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v4.0.3",
      revision: "0ef59aa853dd0497316091a5a65a698b7ea6e4d1"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 arm64_big_sur: "d1dca303e52b624d30980091076c1d5e3c1a47a773a54a7213ac30051bafe644"
    sha256 big_sur:       "726838d541a6496b8beec4f46ca743dad39bc34e76f3cd3267761a95edb5a43f"
    sha256 catalina:      "cfac892b4e156c6bb48cb15b08183c955b80246529a5d4a4d000d7c97c8ddbbe"
    sha256 mojave:        "9a1087cfc39f8c0d52c44d03ff16587ea72b9bacdb0233a5dfd47c6622916e62"
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
