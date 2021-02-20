class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.7.0.tar.gz"
  sha256 "c6415a8f239ade58644199f0d021e90a0f554142c577a4a14e32d99bbeeffebc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12e1cdab31e986b5fe4b42df7880b70c413b2224c962b65bf63a56d258d35390"
    sha256 cellar: :any_skip_relocation, big_sur:       "798b58a1c47c0198be52e0605e186abcc8706c05497f8d165ab7c918f073f9fa"
    sha256 cellar: :any_skip_relocation, catalina:      "206c26baa2c75ed1eb52a511db3c1010cdd9278ef9766c972e58f80eca317ec7"
    sha256 cellar: :any_skip_relocation, mojave:        "b1649f24a58cda7ff00033713123b198fced346dc136ad215f5c54cf4dfd8e20"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8edff5868b49d3e96be74dbfd2287c95a7721963fc8b06410a4c903da7e16167"
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
