class TrezorBridge < Formula
  desc "Trezor Communication Daemon"
  homepage "https://github.com/trezor/trezord-go"
  url "https://github.com/trezor/trezord-go/archive/refs/tags/v2.0.31.tar.gz"
  sha256 "fd834a5bf04417cc50ed4a418d40de4c257cbc86edca01b07aa01a9cf818e60e"
  license "LGPL-3.0-only"

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
