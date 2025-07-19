class Toolbox < Formula
  desc "MCP Toolbox for Databases, an open source MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a18dd9e173ac008f725d7111b8d70b2053dfe99049795d73a74f38ac18227b21"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_releases
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"toolbox")
  end

  test do
    (testpath/"tools.yaml").write <<~EOS
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    EOS

    require "socket"
    require "fileutils"
    port = free_port
    pid = fork { exec bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s }

    sleep 5

    begin
      TCPSocket.new("localhost", port).close
      assert true, "Server is up"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      rm(testpath/"tools.yaml")
    end
  end
end
