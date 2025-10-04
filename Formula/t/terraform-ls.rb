class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "021340fa9b317d90d085ab13cfeaa7c0b802fda0ac03a8bd4e467579f909cd54"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b152ef992d25067a5814c7fc47fc7875a3a0f2d960954be3f4764f0e8d5c44d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b152ef992d25067a5814c7fc47fc7875a3a0f2d960954be3f4764f0e8d5c44d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b152ef992d25067a5814c7fc47fc7875a3a0f2d960954be3f4764f0e8d5c44d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e1df12a494bb30168817b66239132177021c9ad0c9c2bc383879705245cb626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6363e8dc8df3b10915dc094665957a0c567724b412acb80150681236f638458f"
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
