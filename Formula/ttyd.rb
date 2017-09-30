class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.3.tar.gz"
  sha256 "6eed82895da1359538471cbcc82576c4a21a4c6854e1f125fc55215f7c51da52"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "12404d1059ec62c1b88a0ad8cf4aae013c56cea79423b9d75285fef19a59958f" => :high_sierra
    sha256 "189f4696683da2b96c54d7549383cefbe3f04ae7c9cbf506ff9c470562be4ebb" => :sierra
    sha256 "1adbea0ee3eb0357228b306309c49b58db3aa213b72ac9515623102b569c07c2" => :el_capitan
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
