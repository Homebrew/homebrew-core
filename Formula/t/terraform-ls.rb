class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.8.tar.gz"
  sha256 "1d2e725e49f08150ac4f9d3fab4961d56dde7f9f62922ce0ccdf93feb408c24c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5713c96f7a0d4def88125e1cbaa71bc9a0c4d2e2b2100bee34323ad32636ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5713c96f7a0d4def88125e1cbaa71bc9a0c4d2e2b2100bee34323ad32636ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5713c96f7a0d4def88125e1cbaa71bc9a0c4d2e2b2100bee34323ad32636ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "97c3494c7bd1b9e4fe8bcf301c9c4c84c98dc6244819b6f19f02d14d75449ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4fa524c8b2f1e09250bf4c3ed06d4f1fb5f51110500e0d354afd4ec87db9f70"
    sha256 cellar: :any,                 x86_64_linux:  "d99cfb325e998f7c312ba2e10f5ec808385033e820da81ce87db14c1d3c3da6a"
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
