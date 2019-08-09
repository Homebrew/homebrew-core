class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.5.2.tar.gz"
  sha256 "b5b62ec2ce08add0173e6d1dfdd879e55f02f9490043e89f389981a62e87d376"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "7e45c24f3146519cfc50dee0c88b79d3f990dc883607d3736b92bf54e61f556c" => :mojave
    sha256 "b06844f79f440bdd9ad490b167d98633bc68a8ffdc94297ebbd89634017f189f" => :high_sierra
    sha256 "ff1bc58472594657ccbd57aeb7efbc84b896a255d475013d9897081c62220028" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl"

  def install
    system "cmake", ".",
                    *std_cmake_args,
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
