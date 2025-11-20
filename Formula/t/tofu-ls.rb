class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://github.com/opentofu/tofu-ls"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3163abd91f9664a56b0ace41592795d03aee6ae6ae9d3d33f92726e4c66be011"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcbc5c21dc7bb4f43e492fbe8693888b72c979434103ee8cb0f07fe66a9d92d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbc5c21dc7bb4f43e492fbe8693888b72c979434103ee8cb0f07fe66a9d92d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcbc5c21dc7bb4f43e492fbe8693888b72c979434103ee8cb0f07fe66a9d92d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "779aae4a97cced2ff450ebc5621dbe233d9c594ae65816d7686b510eb7b6eb63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bedc584848aa75636c41ea7ba1225ad6b56a7d919168a1c1fe5ec0007df2ea6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97aabd183f28d91d19157fe67d078c561cd9721c51d416e2cf7eb9cf0453e45c"
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
      exec "#{bin}/tofu-ls serve -port #{port} /dev/null"
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
