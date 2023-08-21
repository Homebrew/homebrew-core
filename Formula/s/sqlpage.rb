class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "17db0105b9253c60755402193932a9dd641087842457cbb902ff11d0b0cf54fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0014a5a8b30b07f74dcd50611487e244611ae4365b9b7296486f4962c9757c88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca9c08094b18c2bfcf2fd766064d463637e1888f43e73079b81e6aec8db2fca2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2719c2f299816b54621a6164cc355525482e6bac368941e4d262dcaafa7d3e6e"
    sha256 cellar: :any_skip_relocation, ventura:        "93c100e94823706d4212c53af52da397bf2f4e90cf53f29cbf1d7bc2f4e79678"
    sha256 cellar: :any_skip_relocation, monterey:       "066ddb6405dcbdd5dd802b544a65ef67a35772de0fe01bd429ab532f76e060f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "acdf6f342daae72ed70706c133a6b75425c92e888d95bc386d6b991259ce0fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab22ec6ed90ee7bee7816450e78080c0beb40cea606f26657216ad39f9b1e294"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end
