class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "5a4fdd3e2a4fcf78b9d5e48c1f0a50d00a948f06d67f639f4a6217630eac396a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39baf93de6f5e60fce5ed287cbf3dbb44fcb17f4e0d90b0650cf3caa3a4cd321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39baf93de6f5e60fce5ed287cbf3dbb44fcb17f4e0d90b0650cf3caa3a4cd321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39baf93de6f5e60fce5ed287cbf3dbb44fcb17f4e0d90b0650cf3caa3a4cd321"
    sha256 cellar: :any_skip_relocation, sonoma:        "787d7f43b084c792fd0b9f9635bccf7df1719a5fdc53c7c608fba519816d4aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc191a268300dff5e9239538976eb95e785cf165375596874064a861282c402"
    sha256 cellar: :any,                 x86_64_linux:  "74fdd846e6abac5fb8abbabab9a878cd65523f349b3190102f7cf85c97c6f182"
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
