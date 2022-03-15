class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.9.1.tar.gz"
  sha256 "1ee0d1b04222fb2a559d412b144a49051c3315cbc99c7ea1f281bdd4f13f07bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19f9008288353d1cb4743bcefa8951d41be65f92da8c6a4f671a5c86452619c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "829d7783c8408d0d9a5fe2b94c597e9c0eb1f758091276f1979b9795e907b5ae"
    sha256 cellar: :any_skip_relocation, monterey:       "a0eda1c30c33d2e262274efc21ad54b4810362dbcf4fa4d4dc1b2d36fa6e7fa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "948cafc258366f59ce6bd0d8f0b8260dc7a7b383d15f977cff982a0e63bbef0a"
    sha256 cellar: :any_skip_relocation, catalina:       "a8055db63e1de15a6b0301fbff02d01d2fe66d367baa35c8af412f80623b13e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9524a686c76ac45971b8a8fc80e2782d8b9312805e8fa2ff8d98d9513b98110"
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
