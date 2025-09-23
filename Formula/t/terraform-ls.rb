class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "58c978e43c3dd9033470e37362204e1158237619eb2c97a83a7c780949a5c4be"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebbab99e1504a122d25a7697b93f2318031f76ec6a1eff16722377e92d4c4543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfafa444af3d30e04177403b57b5306ee1c22fbd6997a399a998dcb74186e5f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfafa444af3d30e04177403b57b5306ee1c22fbd6997a399a998dcb74186e5f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfafa444af3d30e04177403b57b5306ee1c22fbd6997a399a998dcb74186e5f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "53b72572addf56be2ecffa9e0eb350ac735f221295f6161e0b8eb905813994cf"
    sha256 cellar: :any_skip_relocation, ventura:       "53b72572addf56be2ecffa9e0eb350ac735f221295f6161e0b8eb905813994cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314e75cdff802992bf9417df9de07e7e61f50fd54a9ad8e5c321cab07a7a8171"
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
