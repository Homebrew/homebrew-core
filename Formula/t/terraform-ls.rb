class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.32.2.tar.gz"
  sha256 "b216cdd99f94ba202d541e679193c530c2d86c69ea91dfb381597f75d5341efb"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed6b1ad5cac1a61ec5889c10fd1539144c5a56093c41eb67363ca897bc1c3e63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a90d1fdb8ab3a1a4390a0a35f02cf38dd0ba824b20c9b9d1c228a6335cb3078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f645e4b5c2ce0bb96c3c9d80943860aca63d09e18700b4a9b86edc588fb4efd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f6895fa33fdd83519708da09f5fcdfc32aa31c3c25461f2af80a9659f4048f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b8d02bf77b188e3c7243d663c5ce669331589efddd7435a690e7c11118fa5620"
    sha256 cellar: :any_skip_relocation, monterey:       "c86406e5918a32c2f83ea5258bfadef0cfb3ab76439075a7d37a0aa1f1df46fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5b89d151d78f59ae36b17dda8d0962faecf714768f2236d0fcee0296961a39"
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
