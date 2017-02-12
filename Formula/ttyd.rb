class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.0.tar.gz"
  sha256 "1b756ff3782f31ec4677cde4642bc3ef44d52d3b85625eed402405c689d877c0"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "3c0ab2471ea88a84a7a8a0de8d29ed508f3393cc7bffd39f8678851119649186" => :sierra
    sha256 "1e7b7e7f0f47b7543647d3c2f26a17120cd203ad980ffc75045a5fc5aa8443d4" => :el_capitan
    sha256 "f8acba8f4623abb75f2be9fdaf0fe4594b65460ada29826e271280cdef431c25" => :yosemite
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
