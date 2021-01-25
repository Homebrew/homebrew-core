class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v3.2.3",
      revision: "ff8c8f51c28417826ebd2a2fce9681201ff3a766"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "90bc5edee632cd0d3dc1f8031aaa1d13f30f53394061564c58f2091c4f5dea95" => :big_sur
    sha256 "7a083eee1d11f79a22dbc0bf1f86b5f05f41f552b12e00a57a5a8afef0906e7a" => :catalina
    sha256 "9d6d94023910b76331281609329c717d8ed2efe7c5a64744a86684ef302bc76b" => :mojave
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on macos: :mojave
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
