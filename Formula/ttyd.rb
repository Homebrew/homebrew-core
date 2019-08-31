class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.5.2.tar.gz"
  sha256 "b5b62ec2ce08add0173e6d1dfdd879e55f02f9490043e89f389981a62e87d376"
  revision 2
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "01c301e0e4faf1a27f8964d46d311720dafe4d133b1848bbbd0eb747335c10ef" => :mojave
    sha256 "543808131b2d38d1bf1eafa7b547ffd9b141e9b264cad86aeb3f91a89a2373d8" => :high_sierra
    sha256 "a3c16fa7dfe029cad28bfe5fe79e063401e7ba08f6d1e7b59620aeae1f81f166" => :sierra
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
