class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.7.tar.gz"
  sha256 "3b4906ef075aa65f65e7e53cc84eedf91fd55b944598b1d3cb61e41f90de6a85"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7aebfd3fe062730ad42374d9d59716eea3bf44ef685120ea8257c6352592c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7aebfd3fe062730ad42374d9d59716eea3bf44ef685120ea8257c6352592c02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7aebfd3fe062730ad42374d9d59716eea3bf44ef685120ea8257c6352592c02"
    sha256 cellar: :any_skip_relocation, sonoma:        "533f10566f9b08a4058e35e293eaca22b1f9551c0eb3872a95860993156168f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "924a6c737b327899c4e7176065a59457647a7d935fa3223018dbbe4bcc74e56a"
    sha256 cellar: :any,                 x86_64_linux:  "c165189dfce536fbfa173d476c3630920a741c2aca40355aa9eec256f798a3aa"
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
