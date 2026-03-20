class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 10
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "ed40285cce6a7d42ae2c8f0fe38d63ba741ad16143641df491b9cd0c3abd6cb0"
    sha256 arm64_sequoia: "cf813272eb937840a84e27b907d743e2e9bcccffe4dd318c717378270ecba429"
    sha256 arm64_sonoma:  "8efb67825e540a44b813428181b17fdee5ff3e9300fa86a86919d0eadd18afcb"
    sha256 sonoma:        "9da6d5ebb891b922b64bdd650f9485983fe6e11476d452ea328bb37ae31658b3"
    sha256 arm64_linux:   "00cfabc8d8efb557e0fa55b24490b7600b01e0b066440b4fc60d9901f035b97a"
    sha256 x86_64_linux:  "7e5a94ba9f95c572b7074ecd1bd21fd67d41132992d249fb4c109c9e2a6bcac5"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}")
    assert_match "<title>ttyd - Terminal</title>", output[..256]
  end
end
