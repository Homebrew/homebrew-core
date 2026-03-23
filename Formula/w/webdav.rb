class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.3.tar.gz"
  sha256 "f6fe475fe88926bb3436e8c9a8821e6d47b22bdebd39074349388bfdd7c5cb5e"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0da5cf725ef49ff831fe9f5e2121b5ad4125b253d13d70c87c55210cec7def3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0da5cf725ef49ff831fe9f5e2121b5ad4125b253d13d70c87c55210cec7def3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0da5cf725ef49ff831fe9f5e2121b5ad4125b253d13d70c87c55210cec7def3"
    sha256 cellar: :any_skip_relocation, sonoma:        "50cf01b9bd3a7a9792bd01a778c7ff0abb72e0261e6424b1ba0ec448ec6a4763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b6005e134fb62a957c0ea423d23f2ad27e069ef52b02f383d5b4626ef57fd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a68233d086b334034264726404a50f87539003697b95b795d88a624dbcbe667"
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
