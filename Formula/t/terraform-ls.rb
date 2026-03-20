class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.38.5.tar.gz"
  sha256 "376188f6e0d2f1454e4144a09e32d0de2a42ef97778f0d500c2813b127f7ab9c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ac96ffa13de5c1561758a4cabba547f4b2a6520e24c298c374b857284e4bdf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac96ffa13de5c1561758a4cabba547f4b2a6520e24c298c374b857284e4bdf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac96ffa13de5c1561758a4cabba547f4b2a6520e24c298c374b857284e4bdf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "860ded4173234e2262c439d937279d9efaf0acf5444a308312d0b788520a3d81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fbf2ee7ed56ea3931ac633693e73312742f6d08623ed22a5d202c0033906a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7dd310f9a50c58c28b95464c1ff033458812ce56210069a55debfce980090ef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
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
