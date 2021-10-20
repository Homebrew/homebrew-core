class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v4.1.1",
      revision: "70e95dde8817f7d891cf63592b49b88fad21beb9"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "d99237710f56e74e5f235a4dae75ed40f0384cb24b6b584bf41728d4a5535145"
    sha256 big_sur:       "2d04f09a31b6ad4becc8288bc2fa244ce03336cdc3aec7ef38edb8b6b57cecec"
    sha256 catalina:      "7dba2a9de9e564d715ce3baf3c8f13252d7e74fabd84dc44b9ecb344b4f1b227"
    sha256 mojave:        "6a77036a93e2acf27274ef4d8c620ac8b19c3f87a26c97f9736ef1bce3f8388f"
    sha256 x86_64_linux:  "f5cf7dad7004c48465916aa1559c3b3fefc462aeadff3fc637cf578dac7d287d"
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
    inreplace "zeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
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
