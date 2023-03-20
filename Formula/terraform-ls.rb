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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "436bcbfefdaaefd3ab5bed2269f037795aca6ae4933b227a1569f340d6a385a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436bcbfefdaaefd3ab5bed2269f037795aca6ae4933b227a1569f340d6a385a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "436bcbfefdaaefd3ab5bed2269f037795aca6ae4933b227a1569f340d6a385a2"
    sha256 cellar: :any_skip_relocation, ventura:        "bbfd9f8f2da648f46e13a76d0e90623d6d3ed6c86481ab022f09b1086a5a7e73"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfd9f8f2da648f46e13a76d0e90623d6d3ed6c86481ab022f09b1086a5a7e73"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfd9f8f2da648f46e13a76d0e90623d6d3ed6c86481ab022f09b1086a5a7e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e65ff9b062b18a913f97991ff447bc0f6cd1abfcab0db09b44cd6c84f31c8926"
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
