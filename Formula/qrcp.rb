class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.6.3.tar.gz"
  sha256 "2d39ba661aad9c60b816bc06f53ef4f3d8747e11d5fc27c104d3687d1e77204c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "857aa5ad50a7a2124a1c37f7f206b25a65d9f3c76bae0ec9223945238c83d0eb" => :catalina
    sha256 "5a1bede14f849cd49815b351325d5f375a9d7dc4d7ae8abd4053505f3fc1b6b0" => :mojave
    sha256 "aba7e5ceb1c788d2eeae3e117e6dcae5c14530e5b759832adac7a6f4296565cd" => :high_sierra
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
