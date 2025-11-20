class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.10.0.tar.gz"
  sha256 "e9ffdae7ba81bf7fd95d64c5a5862754d2ab63319f675356bb94562b6e57f8d3"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9741fca62b9779243b8a2fd6ec5fe5c6116c90aa636cfae5c6406205fc1d73f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9741fca62b9779243b8a2fd6ec5fe5c6116c90aa636cfae5c6406205fc1d73f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9741fca62b9779243b8a2fd6ec5fe5c6116c90aa636cfae5c6406205fc1d73f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a910a61025da599f3a3947b13fb8ddc8c1efebfedc45e81bf280cf007be1272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "290d0dbd6c27ebff9282cc6091dffb4dc0b4c407735953e1dd6f6e6bada7ee4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b47885ed1fc0bb5d20b4c0d71679e0aae6d596473ffc386aca8958919a476f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hacdias/webdav/v5/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"webdav", "completion")
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~YAML
      address: 127.0.0.1
      port: #{port}
      directory: #{testpath}
    YAML

    (testpath/"hello").write "World!"

    begin
      pid = spawn bin/"webdav", "--config", testpath/"config.yaml"
      sleep 2

      assert_match "World!", shell_output("curl -s http://127.0.0.1:#{port}/hello")
      assert_match version.to_s, shell_output("#{bin}/webdav version")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
