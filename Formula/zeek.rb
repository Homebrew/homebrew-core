class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.1.4",
      :revision => "6747d93745a00d24a376d4633280a47a60961e10"
  revision 1
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "8a3b5c9927ba7bf5ed5b092125dd171c89f53980bb7f95486fbcec47310bbc0d" => :catalina
    sha256 "3010d37df0093d43d2c069ea88a36c874a21bb92bc280bdb771c49a9940701bf" => :mojave
    sha256 "8c0a404464b81149411480bb3fd99127080545239c6a2a8758b822e244f2c0bc" => :high_sierra
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
