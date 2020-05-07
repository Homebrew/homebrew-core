class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.6.3.tar.gz"
  sha256 "2d39ba661aad9c60b816bc06f53ef4f3d8747e11d5fc27c104d3687d1e77204c"

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
