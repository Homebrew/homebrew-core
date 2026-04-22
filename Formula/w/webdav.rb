class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.6.tar.gz"
  sha256 "c7a058c97e92f1e743d57c86ad52313ea0e80a718ec02fd38e1e3ace1348b433"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f84828926cf369ad7a580a84c3e2cfead21069ebfa8f3edd85c170448fd6e140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f84828926cf369ad7a580a84c3e2cfead21069ebfa8f3edd85c170448fd6e140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f84828926cf369ad7a580a84c3e2cfead21069ebfa8f3edd85c170448fd6e140"
    sha256 cellar: :any_skip_relocation, sonoma:        "cef640a5aedc7df8ed4a11072a78985275fb958d9fab95a26ce5fca8933457f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5680eea9da9f758ff85d8e45cb67d23be69a8d8bc0019550c8afa94a38ffb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a05695e9daa02c57c0ec79ced9b147570123f26a948a4b11498961161e1bd5"
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
