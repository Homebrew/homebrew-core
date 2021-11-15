class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.24.0.tar.gz"
  sha256 "86932d3659907b52afd804201fe2cee404268ebf1f84bbb3aea3239317ca4f84"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f401a03f7e3e297954c552a542c4f337d7eae99e91d1fe9d80ccadc47ecfdf57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5261f6e58698ecbcb34cecd5a2e7a336edad27a63a87a3bc2e37a0561c612824"
    sha256 cellar: :any_skip_relocation, monterey:       "ec071c546d9a59d572d8c50bcafb8f2b1dc9097e5d9d9bfa7bf275b7331a854c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a81f7c36fd3e42ae6296fe15c6fc3b413719ac10e88bd2aa7faff5437d0b64a"
    sha256 cellar: :any_skip_relocation, catalina:       "ae4ca992a6a47674b79018cc2ebf893e5d4c5ebd2e034749b5757d24046bdec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c785db4c0aade1d287cf57caeb3dafe7c6327db16e0ef8f2cd0378189dd4c2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
