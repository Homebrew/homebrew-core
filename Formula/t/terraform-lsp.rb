class TerraformLsp < Formula
  desc "Language Server Protocol for Terraform"
  homepage "https://github.com/juliosueiras/terraform-lsp"
  url "https://github.com/juliosueiras/terraform-lsp.git",
      tag:      "v0.0.12",
      revision: "b0a5e4c435a054577e4c01489c1eef7216de4e45"
  license "MIT"
  head "https://github.com/juliosueiras/terraform-lsp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e520989a451215fc8aa36173dbce765df4d6abfa73ada73699898677a0c76baf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e98d5085bd970cb5d03bc97f210858c8de0115a912ac62dd7859749b84fd5a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42d32b5aa73ae3c3cb86c68edfcd9d244dc42f78adfc93967529961648625255"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "219f8480f5b9bbee461552d88a1f4da1539a7c1592b3b04be6c46e0a6dd9dadd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb868c9f9037a6797df54f8280d01309e34e700a4b26bced14555e8287ef96f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d30386f77e1057c954a62ff46ced4e7b6cf8ba69b26bcbf137200932d498e788"
    sha256 cellar: :any_skip_relocation, sonoma:         "d330c1aafbb2f100048ec4803e02ddb83404ea850453821cb127a5cca034a97c"
    sha256 cellar: :any_skip_relocation, ventura:        "51b95312d3b714a7ded4ec05810b072904fb55dc75c3d480e11cf6134a97757a"
    sha256 cellar: :any_skip_relocation, monterey:       "10cca16bfcddb58b30bfbe1e3a1aea9c58e4433b9b6260e0108d86fca7cb48c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f3c322749538d6e2872b0c7741d448e60d8552028c378a37ec91fc1fe9f1ab0"
    sha256 cellar: :any_skip_relocation, catalina:       "0606bf7a3d018590555ff5060a38dcec78f57a11927791e7f20caa614caa49db"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e5d4b396b057db51b2ab3ee755341626e016a5da660bd68a2f832b397b89def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eae59625f858958621455404b365659464230b5a54783cb20be44e4569d539f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.GitCommit=#{Utils.git_head}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
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
