class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v4.0.0",
      revision: "7b5263139e9909757c38dfca4c99abebf958df67"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 big_sur:  "dc97e1b05ee465a35da2cfd7fd8c3ff3bd8a229f57934f32e95d053021e73bd1"
    sha256 catalina: "1113a1c88e878f05d17050b11e43b5d3db7debb3f2122d260040611fa99b332a"
    sha256 mojave:   "f6eae52e1144e2245654b36cf4bd668e75a385547c29d7039246fe1f4152bd62"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
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
