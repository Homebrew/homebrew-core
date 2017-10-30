class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.3.tar.gz"
  sha256 "6eed82895da1359538471cbcc82576c4a21a4c6854e1f125fc55215f7c51da52"
  revision 2
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "2ab7a2dda8d3a34aa05ff894a21efc42c41aeb50fe46184e9a9d5e7e438a434f" => :high_sierra
    sha256 "a6087bd41f5634b464d322f94f7545a9a6361a6abc28b3162532d88fd9edac3b" => :sierra
    sha256 "b34204f1d08a5876771c5acaa5521446ed5bf9c8b9481191b9002d8327cf0693" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "json-c"
  depends_on "libwebsockets"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
