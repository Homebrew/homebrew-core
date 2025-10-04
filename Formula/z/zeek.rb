class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v8.0.1/zeek-8.0.1.tar.gz"
  sha256 "ee916387e762345a6ffa84514cc3b66761f110d845a08b88e4a8da48db97ce8a"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "5aeaff3bd1468664b9245f65bac6a3cf8a254ce0138c9302253585022d4e153e"
    sha256 arm64_sequoia: "61285c35ac040f8a5707e22b9276582d05f08c7cfc61c63326e51162a9dd7dd4"
    sha256 arm64_sonoma:  "560df0f425c87cbe002c81bf3785417bd6da70e38a499acd4d140c726ab7b66d"
    sha256 arm64_ventura: "b2cc15f7c6ea28ed0d8f706b74cf8dbae755939201f693e6415f5638d49a08b8"
    sha256 sonoma:        "a1d43e5c37abf02f5ac0b68c89dfbb642745bf0a6bda0ddcb63ba9f50c694d34"
    sha256 ventura:       "adaecd62acee9d5835adb99c88b6f0bb4d52bb58d578f6f4b2fd177d5b9af6b6"
    sha256 arm64_linux:   "ba60ac1095bca371354b39554b05b6a44d3a615e584bed45d55f8bf97ec4bae3"
    sha256 x86_64_linux:  "65ffa5d8ec5a743ccd3786eb536dbde0541d591591d71bea3f7c5520e2307d46"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "zeromq"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

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
                    "-DPYTHON_EXECUTABLE=#{which("python3.13")}",
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
    assert_path_exists testpath/"conn.log"
    refute_empty (testpath/"conn.log").read
    assert_path_exists testpath/"http.log"
    refute_empty (testpath/"http.log").read
    # For bottling MacOS SDK paths must not be part of the public include directories, see zeek/zeek#1468.
    refute_includes shell_output("#{bin}/zeek-config --include_dir").chomp, "MacOSX"
  end
end
