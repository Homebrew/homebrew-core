class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.7.0.tar.gz"
  sha256 "c6415a8f239ade58644199f0d021e90a0f554142c577a4a14e32d99bbeeffebc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "35c4fc732d2e19d78aff13129954130331498d2450f3320fe0a0046623c9adf2" => :catalina
    sha256 "c68d4a7fd6225ddaada0355ed374902f64875d6dda923ad460d2ada1a268bde5" => :mojave
    sha256 "0a05c9f53a4ef108b2716699f3c6f7586221db2b9385f7755c4cf79844c0869c" => :high_sierra
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
