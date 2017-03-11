class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.1.tar.gz"
  sha256 "7133704cab2a5fbc187d96511fad87c00e220ae8ed6cb83220d39205cb928070"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "0b644f9d629a539050d446bec87abb9d924a1ae3e0897ec6e34805a96b6aa847" => :sierra
    sha256 "ad6cb93580f702930a7f9dba957eb4f98b401eb64d3da55ad1b07dafa1086ecb" => :el_capitan
    sha256 "6e043c662898cd777224f43a2ed62283b6b82cac9bfa5825d917239bab4f3391" => :yosemite
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
