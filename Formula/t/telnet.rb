class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-308.tar.gz"
  sha256 "cd4fb9d239a4db871c1e82416c42f8862fab26b9f32e292bcf61151a67174168"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1a535635168f05dd931c23ac8fd36447f5df05ef54bd5d90213c0c78152d956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4d6184f768293938edc0929d220390a2904756f58fb42efe0a530694898689d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f57b68d0525e6a7005b09b5225c86378ef1a694cd38b9a5c139912a296850187"
    sha256 cellar: :any_skip_relocation, sonoma:        "d37c885591f661684c6ee9cdb35ed504dd61b8ccb09e32af00b3bc3f9943e79c"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "inetutils", because: "both install 'telnet' binaries"

  resource "libtelnet" do
    url "https://github.com/apple-oss-distributions/libtelnet/archive/refs/tags/libtelnet-13.tar.gz"
    sha256 "4ffc494a069257477c3a02769a395da8f72f5c26218a02b9ea73fa2a63216cee"
  end

  def install
    resource("libtelnet").stage do
      ENV["SDKROOT"] = MacOS.sdk_path
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      xcodebuild "OBJROOT=build/Intermediates",
                 "SYMROOT=build/Products",
                 "DSTROOT=build/Archive",
                 "-IDEBuildLocationStyle=Custom",
                 "-IDECustomDerivedDataLocation=#{buildpath}",
                 "-arch", Hardware::CPU.arch

      libtelnet_dst = buildpath/"libtelnet"
      libtelnet_dst.install "build/Products/Release/libtelnet.a"
      libtelnet_dst.install "build/Products/Release/usr/local/include/libtelnet/"
    end

    xcodebuild "OBJROOT=build/Intermediates",
               "SYMROOT=build/Products",
               "DSTROOT=build/Archive",
               "OTHER_CFLAGS=${inherited} #{ENV.cflags} -I#{buildpath}/libtelnet",
               "OTHER_LDFLAGS=${inherited} #{ENV.ldflags} -L#{buildpath}/libtelnet",
               "-IDEBuildLocationStyle=Custom",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "-sdk", "macosx",
               "-arch", Hardware::CPU.arch,
               "-target", "telnet"

    bin.install "build/Products/Release/telnet"
    man1.install "telnet/telnet.1"
  end

  test do
    require "socket"

    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]

    server_thread = Thread.new do
      client = server.accept
      sleep 1
      client.close
      server.close
    end

    output = shell_output("#{bin}/telnet 127.0.0.1 #{port} </dev/null 2>&1", 1)
    assert_match(/Connected to (127\.0\.0\.1|localhost)\./, output)

    server_thread.join
  end
end
