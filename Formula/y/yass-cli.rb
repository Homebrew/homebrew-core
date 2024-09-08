class YassCli < Formula
  desc "Lightweight and efficient, socks/http forward proxy"
  homepage "https://letshack.info"
  url "https://github.com/Chilledheart/yass/releases/download/1.14.0/yass-1.14.0.tar.zst"
  sha256 "d3094a173078f70fde6f1a76fb4511873a6e232a8310ecad3138c4d5ad64152a"
  license "GPL-2.0-only"
  head "https://github.com/Chilledheart/yass.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "c-ares"
  depends_on "libnghttp2"
  depends_on "mbedtls"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1500
  end

  on_linux do
    depends_on "gperftools"
    depends_on "jsoncpp"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1500)

    args = %w[
      -DBUILD_SHARED_LIBS=off
      -DUSE_BUILTIN_CA_BUNDLE_CRT=off
      -DCLI=on
      -DSERVER=on
      -DGUI=off
      -DBUILD_TESTS=off
      -DUSE_SYSTEM_MBEDTLS=on
      -DUSE_ZLIB=on
      -DUSE_SYSTEM_ZLIB=on
      -DUSE_CARES=on
      -DUSE_JSONCPP=on
      -DUSE_SYSTEM_CARES=on
      -DUSE_SYSTEM_NGHTTP2=on
    ]

    # we cannot use the homebrew's jsoncpp because it is compiled to system libc++ library
    # and not fitable for our custom libc++ library
    args << "-DUSE_LIBCXX=on" if OS.mac?

    if OS.linux?
      args << "-DUSE_TCMALLOC=on"
      args << "-DUSE_SYSTEM_TCMALLOC=on"
      args << "-DUSE_SYSTEM_JSONCPP=on"
    end

    system "cmake", "-S", ".", "-B", "build", *(std_cmake_args + args)
    system "cmake", "--build", "build"

    bin.install "build/yass_cli"
    bin.install "build/yass_server"
  end

  def caveats
    on_macos do
      <<~EOS
        This formula only installs the command-line utilities by default.

        Install yass.app with Homebrew Cask:
          brew install --cask yass
      EOS
    end
  end

  test do
    assert_match "yass_cli #{version} type: client", shell_output("#{bin}/yass_cli --version")
    assert_match "yass_server #{version} type: server", shell_output("#{bin}/yass_server --version")
    if OS.linux?
      assert_match "TCMALLOC: gperftools #{Formula["gperftools"].version}", \
        shell_output("#{bin}/yass_cli --version 2>&1")
      assert_match "TCMALLOC: gperftools #{Formula["gperftools"].version}", \
        shell_output("#{bin}/yass_server --version 2>&1")
    end
    assert_match "Configuration Validated", shell_output("#{bin}/yass_cli -t -logtostderr 2>&1")

    server_port = free_port
    local_port = free_port
    (testpath/"server.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "username":"",
          "password":"",
          "method":"socks5h"
      }
    EOS
    (testpath/"local.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{server_port},
          "username":"",
          "password":"",
          "method":"socks5h",
          "local":"127.0.0.1",
          "local_port":#{local_port}
      }
    EOS

    # test configuration (cli)
    output = shell_output("#{bin}/yass_cli -c #{testpath}/local.json -t -logtostderr 2>&1")
    assert_match "loaded from config file: #{testpath}/local.json", output
    assert_match "opened config", output
    assert_match "loaded option server_port: #{server_port}", output
    assert_match "loaded option local_port: #{local_port}", output
    assert_match "closed config", output
    assert_match "Configuration Validated", output

    # test configuration (server)
    output = shell_output("#{bin}/yass_server -c #{testpath}/server.json -t -logtostderr 2>&1")
    assert_match "loaded from config file: #{testpath}/server.json", output
    assert_match "opened config", output
    assert_match "loaded option server_port: #{server_port}", output
    assert_match "closed config", output
    assert_match "Configuration Validated", output

    fork { exec bin/"yass_server", "-c", testpath/"server.json" }
    fork { exec bin/"yass_cli", "-c", testpath/"local.json" }
    sleep 3

    # test funtionality (cli)
    output = shell_output "curl --proxy http://127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
    output = shell_output "curl --proxy socks5h://127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
    output = shell_output "curl --proxy socks5://127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
    output = shell_output "curl --proxy socks4://127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output
    output = shell_output "curl --proxy socks4a://127.0.0.1:#{local_port} https://example.com"
    assert_match "Example Domain", output

    # test funtionality (server)
    output = shell_output "curl --proxy socks5h://127.0.0.1:#{server_port} https://example.com"
    assert_match "Example Domain", output
  end
end
