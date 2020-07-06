class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.1.tar.gz"
  sha256 "d72dcca3dec00cda87b80a0a25ae4fee2f8b9098c1cdb558508dcb14fbb6fafc"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "fcee8b0eba8796215e26ed96dd75d045c2c5ad799b2a19529a2b4b2d1300e04b" => :catalina
    sha256 "641c9906011d497631c1abfd40a18c94c98b01a7f01f3242c22f86fa1b2678ba" => :mojave
    sha256 "cd20960e64da5512ac6630ed04bf21aad7cb09c2b3ca5430b68006b7b5e61704" => :high_sierra
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
