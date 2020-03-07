class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.0.tar.gz"
  sha256 "d14740bc82be0d0760dd0a3c97acbcbde490412a4edc61edabe46d311b068f83"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "5d4775fb114fc7758e1a67deccb2fb2d1fb8290548f5ee808f08a689a3e8265d" => :catalina
    sha256 "fb0a0532053de90147c4f02a79b321430a0444a0586438ea0260bffe6ba5b96a" => :mojave
    sha256 "af8e0d5340329843bdee2aab019608d83ee5dfcb190c165e33a0f6590cbf08be" => :high_sierra
  end

  depends_on "cmake" => :build
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
