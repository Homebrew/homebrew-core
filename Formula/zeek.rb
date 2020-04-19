class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.1.2",
      :revision => "df348b789002454cd0386757f3783f04398e5ae6"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "5927d057913571c249e400ad3b9829489ade2cfca49919ef75fe65cc628c9d52" => :catalina
    sha256 "c0b510e132f50c089e6d2c302b00e17b7bd0771efbc8aed154890785379bcb28" => :mojave
    sha256 "0cbd50046531824910c501d10d9cbc7137f31c4f1657fd2c0882260ec2fb4845" => :high_sierra
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
