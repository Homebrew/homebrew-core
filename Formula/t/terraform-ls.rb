class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.32.4.tar.gz"
  sha256 "a7d9c19c9118b4815b268fafcd49d0f663eea111a63bc9519a7896b7347997ed"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c72944d7c81c36331a3b7d803437ba19d4db9e828cfaaf35382b1bc0bedb7b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b58dd2fcb83c22e58ab30aef86c5d948737f4a712c71bdb9ad7f9ad276ffce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d1076c4d66ba087d4108a08259f5cd8be734f00db5cd4e84d48c03d612518aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe0bf79aa971bb05f71e4347d31a58722e703ab7502f1a0f8f6a6c304fd0e4a5"
    sha256 cellar: :any_skip_relocation, ventura:        "ec6fb3d71b98199d080d5d4bef22d307ba3913a30d5c2e4a032f70dc1c7d1a32"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a80d6020bfc996738130a65efb647e8fa3c2987da5f807ae4ba1f221ce5cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "637061b00f656bab1ac01f5e231949f2150d8bc4ca7a958a2d35cec34e321685"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-ls serve -port #{port} /dev/null"
    end
    sleep 2

    begin
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
