class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 11
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "b0285d45774be9ad71801ef8f588bc9b8be96cc9da2be6d7cbba6c3701701913"
    sha256 arm64_sequoia: "f81449aaecf0d71e3679c230904eaaf746b2fc61b3186870a8c2f33e38eb8404"
    sha256 arm64_sonoma:  "315c508acf0d28994704dc8617106908c5e24dbcf680c55fb0a353b732db13f3"
    sha256 sonoma:        "ca9817e17c911a710a9df297cb195b80f4af2a9098f460409bf9c7c0910de5d1"
    sha256 arm64_linux:   "80a24784f939cef75c9af2d4ef862b3813365fd9cd11520be520c7aeda4dc5e2"
    sha256 x86_64_linux:  "921dbd457a02f4578317da406a081155dc5c88c9cbdf0c0926a2d10b747c2109"
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
