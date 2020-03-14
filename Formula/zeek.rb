class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.1.1",
      :revision => "2c8d2af0e7b9456ee5e2fe1d20673be245818f62"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "860785ea11ee30ae21713e43e48b01d20134ef274ddfed08cef3ec00c8cb984d" => :catalina
    sha256 "a3033d1bac9fe0e3cd2fed91abb007dc1c7d811b23a2d135d9c64a12476cfaf5" => :mojave
    sha256 "141eb85540783018abfc4dc8345b68ef06b83a9e4244c552dd7e7befd4c0acfb" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "openssl@1.1"

  uses_from_macos "flex"
  uses_from_macos "libpcap"
  uses_from_macos "python@2" # See https://github.com/zeek/zeek/issues/706

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
