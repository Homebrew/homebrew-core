class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.8.5.tar.gz"
  sha256 "f432347c3892c97ef31345e93435ca4ec3b5bacf09874635f6f50a610d804b26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17126d0da69e86af27da5a5f519074c57fba00c3587895b802d2b862022123b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8286ab8384850578862e84cceebb7aa8efc5d2bafd1d372a0e9e1f6930a7a726"
    sha256 cellar: :any_skip_relocation, monterey:       "3e3a7ccb0226a080b8d0ef18e85d5e05c9aac9de20ace9c2b409624d475df7cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b90c0f156ce21a2ec39f23405fd1213008d96a8e1d62f17cd0d5c83c17b055ea"
    sha256 cellar: :any_skip_relocation, catalina:       "954c095b0cd034464bd929a3b28855f932d09e0cb59a741939009221f6fdac94"
    sha256 cellar: :any_skip_relocation, mojave:         "a319771dea04ac593d2928e8e937ce1fd5a7c55c67999e9505b258cbddbe226c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "564e4415f63d446ce140cbb3baccae5902ff4be08b041ceb8bc028c2c90376e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test_data.txt").write <<~EOS
      Hello there, big world
    EOS

    port = free_port
    server_url = "http://localhost:#{port}/send/testing"

    (testpath/"config.json").write <<~EOS
      {
        "interface": "any",
        "fqdn": "localhost",
        "port": #{port}
      }
    EOS

    fork do
      exec bin/"qrcp", "-c", testpath/"config.json", "--path", "testing", testpath/"test_data.txt"
    end
    sleep 1

    # User-Agent header needed in order for curl to be able to receive file
    assert_equal shell_output("curl -H \"User-Agent: Mozilla\" #{server_url}"), "Hello there, big world\n"
  end
end
