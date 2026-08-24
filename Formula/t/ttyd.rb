class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 12
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "6d433a3726aa3f167156665bcef2fd7076c593bf6705322b88b76d4ac7f49193"
    sha256 arm64_sequoia: "8e033c105b99fff94359a9534455292539208f3869579548673571ba397f6959"
    sha256 arm64_sonoma:  "a65be2c97b4721cea27863ecde0e2de31102047e5088761c560f9bce203a3e3a"
    sha256 sonoma:        "650810e61dd339b7364960f959fc734d51627b3f10cb9f1e1882879b052e0e41"
    sha256 arm64_linux:   "19ae582d056afbe6edd2f5035fd818129fdcb854b93bdb0356f4c45eae4fe3ab"
    sha256 x86_64_linux:  "0a39cb933e574bef839f2d9913a77f9dd7814ee3c9d708c41fc3fc80b6e1ffae"
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
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}",
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
