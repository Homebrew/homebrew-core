class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.8.5.tar.gz"
  sha256 "f432347c3892c97ef31345e93435ca4ec3b5bacf09874635f6f50a610d804b26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6ea1800b725f5753fc15c0ed5b476f1fc0e25d273f4962774d1e0502b3f5a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bffb8cf3fa70e631d2bb06c1252240a9ca917ff5afa3240316856e780f20ad33"
    sha256 cellar: :any_skip_relocation, monterey:       "f0f9d9be295b4275742d70f874dd162e76e7dada8985e27fae37ac7244ee091c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e85f7e17a9f2a5d54e273e940eb1977713332396e39edd145b783db6c4de95cf"
    sha256 cellar: :any_skip_relocation, catalina:       "3a58dc12ed69cc6c49f29e8d650ae4616dfe95ca3e0b2632aef8d8fcad05b99c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0649b9ed447a8a8d36d9d8cae7d64b285ff36fbb0107bec89f50acaa5a6c956c"
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
