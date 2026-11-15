class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "bd755d769b2116cd25b3634e120d5c7295c330f7179a5d9cdf13af67c95da34a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba2f4176cacf594d14d2b4659588041cc19d8a987c8e6da754ca0cbd25c9131f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba2f4176cacf594d14d2b4659588041cc19d8a987c8e6da754ca0cbd25c9131f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba2f4176cacf594d14d2b4659588041cc19d8a987c8e6da754ca0cbd25c9131f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7343e8bd8c406f697a41521010a243e89b105abf11bf046b86e9ea5924738aa0"
    sha256 cellar: :any,                 x86_64_linux:      "45290fa4a72a6d02f4c8d891aaed428fd901e8065711ef3207b7a3712ce78f89"
  end

  depends_on "go" => :build

  # `test do` block binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X main.rawVersion=#{version}+#{tap.user}]
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
