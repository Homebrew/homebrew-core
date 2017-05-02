class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.2.tar.gz"
  sha256 "6fcbdf4e4e630bb72597bcbebd529d57a4de2478040f465e412a6827b73ca46c"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "a5e18683c8d4ea0539149785006269de22a5ca0f0de033d10c499efd3732d50d" => :sierra
    sha256 "86d0941ab94780352eaf695fb05508cfca2ee997b8038934390054be4b95f1a2" => :el_capitan
    sha256 "7a5be26795015264b9d3aa0e9adbe9bd6a0a6c763206b416421907e7e749382f" => :yosemite
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
