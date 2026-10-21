class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 14
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "11f48dfa4ef0f29f80ea7d3e0173b4564272eb91360a2d741c53cb7838476493"
    sha256 arm64_tahoe:       "c9f5788221927bfe0d5e491f0eced92c6369a73e7e968ea712639b66c1864f40"
    sha256 arm64_sequoia:     "aedd77feb2ab16fd9b6faf4c15e47a62e6b1ce3f1342ad05b4b6e70fc04cb3e9"
    sha256 arm64_linux:       "cd87a1a24e6a0d92900681fac6961559ea48f3350fa2e28a3209e3428f02e4bd"
    sha256 x86_64_linux:      "f12a7a7151dc432a48cba81f11f004514ee729e28369e5491970c11e2329e610"
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
