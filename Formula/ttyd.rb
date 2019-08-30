class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.5.2.tar.gz"
  sha256 "b5b62ec2ce08add0173e6d1dfdd879e55f02f9490043e89f389981a62e87d376"
  revision 2
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "aa188ee7b47b2a6e82ad9f28c735ebfbda9507a2890d009a2814d9191bcb05b5" => :mojave
    sha256 "1234caf20914cda657ded88df7ebb8766f02558ff2647d2e72c6782d07f5dcde" => :high_sierra
    sha256 "5142dee54d8eeffcae84537122fece72015657eadfb9994216d8ea6cdfa86b52" => :sierra
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
