class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://github.com/claudiodangelis/qrcp/archive/0.9.1.tar.gz"
  sha256 "1ee0d1b04222fb2a559d412b144a49051c3315cbc99c7ea1f281bdd4f13f07bf"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38d90c6db412242ad80b6757e322b01ef67950ab05515c30acf8e66f9e378ad3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c78211f9d68f2d3cd87480480e1bbd77d41c1bb901cb8a3de9a485f33daf0586"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9e802476922a3b2838bf05a8e94ee9499c9c80178f1a269b6ab6cb09506506c"
    sha256 cellar: :any_skip_relocation, ventura:        "7a9f8ec7bf540c48a95566c06d6619ad4bd7452f53b34a09b8729ffda68eabcb"
    sha256 cellar: :any_skip_relocation, monterey:       "f48c800a4db6a665e865152fd0aa73341c23e445c6c4343175af56a4e88c0bc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "688fd46790df307ab1bf1b52fd8c65b3af682c55aaa4a210d49aba3e32bb3707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ccd045ad89452ab621622c1aca81888f9d57242a4f8360284b77580eee2efe8"
  end

  depends_on "go" => :build

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
