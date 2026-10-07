class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 14
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "23dfb9594dd60bc667d82b29dc63d37393d38be118abf5a96578ae82972124bc"
    sha256 arm64_tahoe:       "671319f64edff8cc2057d0efaeec236cb6165839aada86511244856869b52d52"
    sha256 arm64_sequoia:     "c4fb90cc00ed4ab3349bc94c5bb3b5b304410a59dbba017c216e6d187747ed01"
    sha256 arm64_linux:       "2bc520ac4ff44b1099e7f0984d7daad150775740f8d76602041a56b2b2ff1743"
    sha256 x86_64_linux:      "469a204b7934095b99aae174c246971e6426aa4be148984edc28516463fd0061"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@4"

  uses_from_macos "vim" # needed for xxd

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}",
                    "-Dlibwebsockets_DIR=#{formula_opt_lib("libwebsockets")}/cmake/libwebsockets",
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
