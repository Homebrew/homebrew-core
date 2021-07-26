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
    sha256 arm64_big_sur: "17c9c9b4397a650d502de42b72db39dc41c9e7bc9e07c9d949480d4076c4cd5b"
    sha256 big_sur:       "48f4fc5ac41e8aa13a8f84455e7e575b6357d7c84a448e2646ee161dad3f83aa"
    sha256 catalina:      "ef67277c8fc28f2759462296f814ccc53d251154334e409c5dfcb3e45356bdc7"
    sha256 mojave:        "74cb86c0e309abb6634066e4ff47a8f1a973548f1ae09f6146e895d7250127bb"
    sha256 x86_64_linux:  "4d93103756e5a2de71144cbed021b1add3436d7109e975327eda94c7f6990bf1"
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

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

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
