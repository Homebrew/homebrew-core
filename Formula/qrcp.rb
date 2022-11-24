class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.9.1.tar.gz"
  sha256 "1ee0d1b04222fb2a559d412b144a49051c3315cbc99c7ea1f281bdd4f13f07bf"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "889a88eb8962304e9a0f9cdca7f1a879585c99d7b7ee54fa89b9a670813d3a9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72b5897e63349242e2c60cae3662a9126b626a0c61955dea13acc7985a91194b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9561594ba75dca10b0ba413a3df8055f7009513a71694ea1ddab8f8ab7bdd125"
    sha256 cellar: :any_skip_relocation, monterey:       "d50f012601dc63a2cd69060bf28cf33a0e31b1af92c7015667a3e9037df85732"
    sha256 cellar: :any_skip_relocation, big_sur:        "b413f243a3eb24dae58770f62005538e1c851c48781c75f5a755b87e9580b61f"
    sha256 cellar: :any_skip_relocation, catalina:       "500c92e7643f664db127ab5c0eec5b4120e8715b0042100e619c2f986bce6137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28ca8979e794d2e04176f125c1445082a325930ec608c46e27e8f004a5f3542f"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"qrcp", "completion")
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
