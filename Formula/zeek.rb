class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v4.0.0",
      revision: "7b5263139e9909757c38dfca4c99abebf958df67"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 arm64_big_sur: "ecf9859f3e793334e9fdce6055c6d419d977cef2031b28e0a3a41c73da62b769"
    sha256 big_sur:       "2cbe1b60773d0edd58636dc4574cc00449fd382700379bab84c7330e45a391a1"
    sha256 catalina:      "73b6a43d41c75a69fc0d091d6d1f3a32c7edeb03a3b7e4a5072b33eba7ffd823"
    sha256 mojave:        "b6b358037881bf3fa49d33faa4826b2973323fd7392ce7c7793c9e2450c73612"
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

  def install
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
  end
end
