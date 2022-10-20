class TrezorBridge < Formula
  desc "Trezor Communication Daemon"
  homepage "https://github.com/trezor/trezord-go"
  url "https://github.com/trezor/trezord-go/archive/refs/tags/v2.0.31.tar.gz"
  sha256 "fd834a5bf04417cc50ed4a418d40de4c257cbc86edca01b07aa01a9cf818e60e"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "397b7e64540efe897cb2c5fadab51d577742e20d462fa1f95c20e1375bce5dbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78091c03859934522369c96f13b21c52c9cc8c2128b4c239bc1729f29402aa30"
    sha256 cellar: :any_skip_relocation, monterey:       "8efd4d6faa3d474c11896774107f7458ed026dca8d4559580857d328364a1c29"
    sha256 cellar: :any_skip_relocation, big_sur:        "69cf4437c5dc30489249a5b107d5e606b014c4550654641f8fa8fbef61061f8e"
    sha256 cellar: :any_skip_relocation, catalina:       "87843da946e34a4c2316e75413a78b9eb8504d06f3be3fd6acbcd96c8e5dad64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc59026f5d67a9008879c708acca64295e52abeb96edd6a93330d17ec5a87fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"trezord-go", ldflags: "-s -w")
  end

  plist_options startup: true

  service do
    run opt_bin/"trezord-go"
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    # start the server with the USB disabled and enable UDP interface instead
    server = IO.popen("#{bin}/trezord-go -u=false -e 21324")
    sleep 1
    assert_match '{"version":"2.0.31","githash":"unknown"}',
        shell_output("curl -s -X POST -H 'Origin: https://test.trezor.io' http://localhost:21325/")
    assert_match "[]",
        shell_output("curl -s -X POST -H 'Origin: https://test.trezor.io' http://localhost:21325/enumerate")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
