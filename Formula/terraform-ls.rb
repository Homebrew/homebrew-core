class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.16.1.tar.gz"
  sha256 "e466d782fd1e2bede2f90e5677e1fd18df4a23476ebb08212502a3e955667736"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31d82105d4de66fecd97f3f144534ab48fb7a2352c55c4223bfd260a92ea86a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "35872acf6aad3fda0e752178d51d76cf01fb83e6ec72e465dd3d4da1b255f2b1"
    sha256 cellar: :any_skip_relocation, catalina:      "aaa06010ec3cba3a02b785d6044869dd33f4b7d0e7e863998cd702b211f466d4"
    sha256 cellar: :any_skip_relocation, mojave:        "74116b2a90f58b1bd6c0d4bda96dbca250bbd455435b294b9923b477eef2699e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
