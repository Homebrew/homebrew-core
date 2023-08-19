class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.31.4.tar.gz"
  sha256 "85f33382834b2698387c07b476dcc1e64c2928c00df5e830938b6b8873b08fb9"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58f641a7f925219c1c538c143fdb5ea5edb38c358aa286879be52abc82ea94f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58f641a7f925219c1c538c143fdb5ea5edb38c358aa286879be52abc82ea94f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58f641a7f925219c1c538c143fdb5ea5edb38c358aa286879be52abc82ea94f4"
    sha256 cellar: :any_skip_relocation, ventura:        "01475698c78aa0986912814fd7eda576f7f11348527090131cd950e308f382a6"
    sha256 cellar: :any_skip_relocation, monterey:       "01475698c78aa0986912814fd7eda576f7f11348527090131cd950e308f382a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "01475698c78aa0986912814fd7eda576f7f11348527090131cd950e308f382a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "188032984cb16e39e6f01d19949e8eb5588e70662a69e1a88f69e1329a626646"
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
