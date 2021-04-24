class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.8.4.tar.gz"
  sha256 "b77673bad880c9ffec1fa20cef6e46ae717702edd95bca3076919225e396db57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "321157141eaf511089d396be585baa8eaea15f43aaae9259d5e7a663d0a764c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "7038c69582572ca6349b76988869971801c60182fedf579f47998bc47551ad01"
    sha256 cellar: :any_skip_relocation, catalina:      "f063aace4506bca0113e3dc0210134feb4a9c0f36f76c29327373066aa177451"
    sha256 cellar: :any_skip_relocation, mojave:        "0709ace3c107c6ad7f23563e085a3ace600d763fc062b108211f60a710a737d6"
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
