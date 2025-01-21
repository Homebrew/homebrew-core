class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia:  "546f6c28e74064f283eeab9770b1779544376272d25e83e9253feb9be9abed6b"
    sha256 arm64_sonoma:   "e561aa5ac9af88c33e697043bf1480261b50dab24f124986fedae77acc76bcec"
    sha256 arm64_ventura:  "eb7c74c84404c738198040209c88e13d594d422c647b19c57bfc16fee723f3dc"
    sha256 arm64_monterey: "74a57b3f5474faea250634bf2b41c975d972f0dad594d94640e345390079b754"
    sha256 sonoma:         "3d3854352a3efd90d29ba6aea68d0256f89650ea6e0981af782dc67afe7a64aa"
    sha256 ventura:        "df6408397fbce04ff9835ba2b1d1aa0c55c1099c0c5e48d09945c250a1a7feb0"
    sha256 monterey:       "4cffef10b8c4893c8d87967dc98221f7f12ff7955eff0970edfeca2ba007d58b"
    sha256 x86_64_linux:   "da86d1bef2794255251367f1dbb944ff1b877756302540288247db81e79e82da"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib}/cmake/libwebsockets",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    fork do
      system bin/"ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http://localhost:#{port}"
  end
end
