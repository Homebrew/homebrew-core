class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    sha256 arm64_big_sur: "17d9729f4c4c7162f8adeb361a64c30c2cfd5ed987728dd0692efb1096d9c5fc"
    sha256 big_sur:       "3a8e47c44c2c09a23b83bf834a389d43907493bde07db0eea1ebb42b505df6dc"
    sha256 catalina:      "918b9ae7215da2a72e88ff0456cf8be93e61249fadd97f1cd9ec09e71152b1ba"
    sha256 mojave:        "d550e8e2cbae8483440e802a3d02d4beba1aec4c30d58e6cd27c07d69aafbe0f"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "vim" # needed for xxd

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
