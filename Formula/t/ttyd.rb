class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 4
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "a4ae9467ebcefdc8e31329e6e8f4b98d93212fa08a00b8bd35e82634dc832de4"
    sha256 arm64_sequoia: "1ddeb18e3c03bbd60d9e819a780c7502f6db64626ff2c27603d4898b8b258920"
    sha256 arm64_sonoma:  "dd34f28666dff192b0d5866040ed0ac9304727e4792134b959b15f58e1a8d5c0"
    sha256 sonoma:        "51c10442a3c083a385b10a93239356778e326c7abe40792c13c127c2f98c817a"
    sha256 arm64_linux:   "cd03e44fe30bc471e158d5a87a4b6becee7900bec03c45b2af0d09f787ef7da1"
    sha256 x86_64_linux:  "34d68c79b1ffaea08fef62d36edbccc18e4a49d52dc3848e22a7026c81e69a32"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
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
