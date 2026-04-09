class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.6.tar.gz"
  sha256 "76df608818567cc02cfba57e23558a5ba561b3aa0a60c2f3abf1a1e2f8b282fc"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cc667223f63e05dabcd321a67ff9cf16519f955bb509e3523b8555b25a47a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cc667223f63e05dabcd321a67ff9cf16519f955bb509e3523b8555b25a47a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cc667223f63e05dabcd321a67ff9cf16519f955bb509e3523b8555b25a47a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "465c3fea02518317ea529512c5e69494ab8538538d6a8179ae87a3c20beaa903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d485871bb53c71cf0bec90314c945e194211ce25b8ea0fcc6cd9d718ec87d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f553f721d7f83284b5e08711398050c6f598c9c2abddcac63ad8fd17c4c09f"
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
    pid = spawn bin/"terraform-ls", "serve", "-port", port.to_s, File::NULL
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
