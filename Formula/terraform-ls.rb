class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.29.3.tar.gz"
  sha256 "20270431728cc4607a7a351139e6dd1db1cba22798a5ca298dcd0c8b7184c046"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78288fcd4cf461987793afe9650610e876dfd3f727e173a9758c879a206bfb58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e9b48b8d5c9b5c2c8ea235cc66f76ad223f570cc95f3b09b37d800e8ba44c17"
    sha256 cellar: :any_skip_relocation, monterey:       "cb415e1ab51c104a6fda225151a7d443bca4b1ff820ea41309023adb6596040a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6157bc0a9cb46345c0f6622b98639d6e5bc958e6e00d920fb38451a4f11f7e4e"
    sha256 cellar: :any_skip_relocation, catalina:       "f93201fa60cea6fb001924bf6f8bc01729b49c32bb5e9156131573cd9bbedd58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b983661cb54463f01f89b18ed4c040c99e57aa9e87a6050af464435b1b4065"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.versionPrerelease=#{tap.user}
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
