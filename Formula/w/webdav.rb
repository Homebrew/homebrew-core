class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.1.tar.gz"
  sha256 "2fa29cd741adae6d0d846ace917d9c4aa18fb4b065bdd0647ad0f8d0fd5b9956"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28251e5ff69dae66e558b8252aba8ac62985c2ea379689da87408dbe788d7c73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28251e5ff69dae66e558b8252aba8ac62985c2ea379689da87408dbe788d7c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28251e5ff69dae66e558b8252aba8ac62985c2ea379689da87408dbe788d7c73"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4a85b129cbd63957651d8ec3fdddc0c849e68350cd4a921f90df15e3abf75aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8502ecfd229c3da0d8e737fc6495b594fdadddd097bceb59199e34ce4eacb44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce4e1369ccdcf1a7f313279004bbd1d2f2a21a619a547e0684f3a26670fa65c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hacdias/webdav/v5/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"webdav", shell_parameter_format: :cobra)
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
