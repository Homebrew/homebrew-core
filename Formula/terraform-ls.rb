class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.30.3.tar.gz"
  sha256 "bd4025876095d980d570c1f237cbdafe812a52e0277545493520ebf65dfaec9f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "254972270e5185a449db57989b89114e537821a7b15380654229b2a44f7e4a16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "111bd68c1c5b905061bd835e8da78b4de3ee1c34931ad6513231222e93e934cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7470db9ab3fd2f69f4acb267858628a0be1a478edf3500dc79768da7439dfce"
    sha256 cellar: :any_skip_relocation, ventura:        "08c2a1f1a39f2c32abe063a7855357fb28d0962e37f8fd18480721c07328b5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "397dcbda6b129e62f39a90bf0176484827fc9a7121ce51d106cd91a105737c69"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d201220b09286d36e0c329050e7f45bd98e0b0f4ae1d69a8328d03a2cce2781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2319cf00c600e419322af76efe19f07992774d5a8c9837831195e11f1f04c62"
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
