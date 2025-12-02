class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 5
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f2677ae10cc49cd5a28caa88ab177de54af7b113ca6ad66e7d70229f87d39d2e"
    sha256 arm64_sequoia: "b53b0aaa0da436d068d5efd44e8560e5fc56f876d27d6f9801e4b6fd1d734dc1"
    sha256 arm64_sonoma:  "70b2dbbe8f7414c1f9163cd297075e7cd9504904a9086620b12eda0ab383165d"
    sha256 sonoma:        "b4bf9a51509b7dd7e793f0eec657664314c9f69443a472175747caccc57d6905"
    sha256 arm64_linux:   "8ba46410b2476492acea1206bac755a6470eebbff59aafaf19c8b6fe52071a01"
    sha256 x86_64_linux:  "439b5c744d77f70a567801339e283f9d630ac07043ca8b45f97aadcb306f34ed"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets" => :no_linkage
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd
  uses_from_macos "zlib"

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
