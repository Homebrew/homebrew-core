class TerraformLsp < Formula
  desc "Language Server Protocol for Terraform"
  homepage "https://github.com/juliosueiras/terraform-lsp"
  url "https://github.com/juliosueiras/terraform-lsp.git",
      tag:      "v0.0.12",
      revision: "b0a5e4c435a054577e4c01489c1eef7216de4e45"
  license "MIT"
  head "https://github.com/juliosueiras/terraform-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb868c9f9037a6797df54f8280d01309e34e700a4b26bced14555e8287ef96f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d30386f77e1057c954a62ff46ced4e7b6cf8ba69b26bcbf137200932d498e788"
    sha256 cellar: :any_skip_relocation, monterey:       "10cca16bfcddb58b30bfbe1e3a1aea9c58e4433b9b6260e0108d86fca7cb48c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f3c322749538d6e2872b0c7741d448e60d8552028c378a37ec91fc1fe9f1ab0"
    sha256 cellar: :any_skip_relocation, catalina:       "0606bf7a3d018590555ff5060a38dcec78f57a11927791e7f20caa614caa49db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eae59625f858958621455404b365659464230b5a54783cb20be44e4569d539f"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.GitCommit=#{Utils.git_head}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-lsp serve -tcp -port #{port}"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Length:", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/terraform-lsp serve -version")
  end
end
