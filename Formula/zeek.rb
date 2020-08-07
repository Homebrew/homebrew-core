class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v3.1.5",
      revision: "468ede389827cbe68505ce36c08d7fd4eb869111"
  revision 1
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "8cebfc7ff014e94454d5bbf3890c08203766f63b5b739ff5c2fa26d0b10aa8d1" => :catalina
    sha256 "7ae189863fc53a17cceaadb251004f6790947566596495c8601dc72dfad26096" => :mojave
    sha256 "6a1b7eeb62e992b2fdd2ea85dfc6ec4245e026a433d67ce7da72e7db29b902a2" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on :macos # Due to Python 2 (https://github.com/zeek/zeek/issues/706)
  depends_on "openssl@1.1"

  uses_from_macos "flex"
  uses_from_macos "libpcap"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DDISABLE_PYTHON_BINDINGS=on",
                      "-DBROKER_DISABLE_TESTS=on",
                      "-DBUILD_SHARED_LIBS=on",
                      "-DINSTALL_AUX_TOOLS=on",
                      "-DINSTALL_ZEEKCTL=on",
                      "-DCAF_ROOT_DIR=#{Formula["caf"].opt_prefix}",
                      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                      "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                      "-DZEEK_LOCAL_STATE_DIR=#{var}"
      system "make", "install"
    end
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/zeek --version")
    assert_match "ARP Parsing", shell_output("#{bin}/zeek --print-plugins")
  end
end
