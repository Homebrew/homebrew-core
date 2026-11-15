class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 15
  compatibility_version 1
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "c12c23ab10ea0ca8de625359fba6964aed32f2c67b3794459a68e83984dd106f"
    sha256 arm64_tahoe:       "cea9d6cddc179d6219e21ed19dddf4b6c51895696e957999c5655c6f40a9fdf1"
    sha256 arm64_sequoia:     "e074e9140fe2e77d597dfb53b841e0c49aa9e48b9f168ac6e9f69ab17f2f9f5f"
    sha256 arm64_linux:       "b2c46232a6a319ba24099a4cb38cd895681fa13204f5d06ff636d73c416da23f"
    sha256 x86_64_linux:      "a646eda3acd22047ed2b590c12b8977f027b10ae6e07c15e305757abd19187d5"
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

  # Run the libuv loop directly as `lws_service` only runs a single turn from libwebsockets 5.1
  patch do
    url "https://github.com/tsl0922/ttyd/commit/fddd63815631223a794f3474869d5685362d5017.patch?full_index=1"
    sha256 "7b98a6acf9df66ffeb77423ff1af75111f220065eedc4157691f59fbac9d3bf2"
    type :unofficial
    resolves "https://github.com/tsl0922/ttyd/pull/1589"
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
