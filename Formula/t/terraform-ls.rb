class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "dcbae6aab18141ea7b2e69526cf248caa49613db234c86f275e049c0b9948ebd"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80dcaeb6f316ad3bf6d740ffde85f16d9e71fee737aa2dd242fcc18fe530f532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80dcaeb6f316ad3bf6d740ffde85f16d9e71fee737aa2dd242fcc18fe530f532"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80dcaeb6f316ad3bf6d740ffde85f16d9e71fee737aa2dd242fcc18fe530f532"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fb9cc828e3d29c3e686c82e7fcf96f4a88964da8dcb8e2142cdcca9d80e2385"
    sha256 cellar: :any_skip_relocation, ventura:       "7fb9cc828e3d29c3e686c82e7fcf96f4a88964da8dcb8e2142cdcca9d80e2385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea139a3b33b83f3926d35deaa7b3a07fb8bcb8c1c0eb7e9a722afd7c56a5e98"
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
