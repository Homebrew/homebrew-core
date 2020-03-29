class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.0.tar.gz"
  sha256 "d14740bc82be0d0760dd0a3c97acbcbde490412a4edc61edabe46d311b068f83"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "200057b5acc12cc45115145e56a074f4d7b47d5ad886ecc5a9cb36e7fa66344d" => :catalina
    sha256 "2622c50c776719257ec250d25c4d4837f3cbebdf025372fa023ade0ea9f5bc46" => :mojave
    sha256 "44820b071a3e4ab8e2a4bf3dea4be710ea348bd8e50149576e971630d0bd63d9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "vim"

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
