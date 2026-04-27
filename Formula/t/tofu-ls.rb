class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "20a71da45069cc2e28f9f2b58f6aed9da33457760adeb037a10aef94126b77f1"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "376b16c5de38d88a4430a9a15306f6f3b8640a66e1624cd578fa0b639f4b6364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "376b16c5de38d88a4430a9a15306f6f3b8640a66e1624cd578fa0b639f4b6364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "376b16c5de38d88a4430a9a15306f6f3b8640a66e1624cd578fa0b639f4b6364"
    sha256 cellar: :any_skip_relocation, sonoma:        "77b35bce6ef46cbe8c52fe68f6bb5575116cb66c3d4c872e3f6dbf3fb7cb94aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d0cb589bdea701fb68e9a9a0f6fc6c19c46944f9fa232cdf8901d11d928b7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d7c7c6a6d90bc5f603baaca626c24a5c9955734c79c06eb9b54b177136d384"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    pid = spawn bin/"tofu-ls", "serve", "-port", port.to_s, File::NULL
    begin
      sleep 2
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
