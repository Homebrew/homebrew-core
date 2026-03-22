class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b491921c707197e5bf5eb4aa7631887f8979a39e383ea14b963a170e68626923"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc7fa752152586e7704036a6e342fb773c0c909bda028a532c26ae48baa245b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7fa752152586e7704036a6e342fb773c0c909bda028a532c26ae48baa245b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7fa752152586e7704036a6e342fb773c0c909bda028a532c26ae48baa245b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4220121b5934da5766c7333d117b2585ecf81857d6c07e19078ee4aaf2bd36e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3939060de992b9e1a3256ba5f365af89b36b3d666f0adac377f6d9b16fc1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "564d414c2acca220332259f8186a74e331ae08e6465ca035b91f60565e752bb9"
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

    pid = spawn bin/"tofu-ls", "serve", "-port", port.to_s, File::NULL
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
