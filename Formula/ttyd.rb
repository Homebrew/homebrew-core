class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.5.2.tar.gz"
  sha256 "b5b62ec2ce08add0173e6d1dfdd879e55f02f9490043e89f389981a62e87d376"
  revision 3
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "c91b3fe23a0aeb86888b8ad9e2990f0a0f43ee15cb58122c12b23d4e7309c284" => :catalina
    sha256 "0ed2b2b2c3bd4767d7d05e0ff104a2556bf52d8015dc4e1b629641d81e4b7e71" => :mojave
    sha256 "08ae9dbd7cd921f15031fb15c373cc64bd05c67ad9b7a13125b41aa735aef263" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".",
                    *std_cmake_args,
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
