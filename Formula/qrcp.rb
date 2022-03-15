class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.9.1.tar.gz"
  sha256 "1ee0d1b04222fb2a559d412b144a49051c3315cbc99c7ea1f281bdd4f13f07bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bac381f8b8a28fea31bfe824a7aa22e45cf3215195226d940a9e899867b14db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38159c798be38412d244b90a17fc4ece1e1fc455a73f74a1d25c14ca6963a9c0"
    sha256 cellar: :any_skip_relocation, monterey:       "e821bac199d4fa84ed10f0a6d036c4140a9237430537e5f0305a5d5ffd5f4fb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "35e22a116f80c16a03720fbd8594bc6632c9b743641220befc232d115cb0debf"
    sha256 cellar: :any_skip_relocation, catalina:       "15671040d5f67509509ecb94e48a6d65a9c35855319f10e660bcd042f9ccfffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0fca2937cc06d6c5d76e067b4bd69511fc24c8e9632b8bd5e2274658a5a1f6c"
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
