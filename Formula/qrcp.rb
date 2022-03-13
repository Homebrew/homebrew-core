class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.9.0.tar.gz"
  sha256 "b50492368909fd6522b6578a4b6a37f173c6897576c5e8e241c2dc7d1201e40d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f79fcde6135b2e5992dc40a0faa0ea84a2b769f2c63f3c05e47b0ef68acc7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b578ba922837b486725dc263076de7a0bdbab26e1fe454b3ae6599baa20ff7e5"
    sha256 cellar: :any_skip_relocation, monterey:       "b8754f842236ebc5d601235d1e05a9b36ba9c972a1d650713afcd2cbbc105772"
    sha256 cellar: :any_skip_relocation, big_sur:        "55513d3f0fe4c60a8128ad984f6c8acc6122964069e50182571ae6bfa122d288"
    sha256 cellar: :any_skip_relocation, catalina:       "8400f9d7b35b94879fa24c62d560a329b8fcefa86f52902de7b441a80a6d9fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "076b823853b442289684e02f00cffb41b5c8fdc5cb5dbf9b82b68ceda868a3d2"
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
