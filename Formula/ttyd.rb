class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.4.0.tar.gz"
  sha256 "757a9b5b5dd3de801d7db8fab6035d97ea144b02a51c78bdab28a8e07bcf05d6"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "b6d3b9fd532e3b9c0542fc5566969812fbf43b65230beabf8b68d62cc00e8e6c" => :high_sierra
    sha256 "4a943020c1f60c595e67725f0deee077cff693e4228c628f2ff60ebd914d8d72" => :sierra
    sha256 "d230f778b8ee31b696f8c841ef5bbc39aff183fc8a11ff536cf6f979ffd5508c" => :el_capitan
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
