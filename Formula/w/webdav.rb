class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.9.tar.gz"
  sha256 "c1a4cad9c45ae7fb94fba77a553b36e0f8d467bbaad81027be6c94af3bc79878"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f73c3ef1c1f728b484ae9516bfbb21faf92b18ae211080c572a13d06d83d7bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73c3ef1c1f728b484ae9516bfbb21faf92b18ae211080c572a13d06d83d7bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73c3ef1c1f728b484ae9516bfbb21faf92b18ae211080c572a13d06d83d7bfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6edf6d971c3df47ccc189cddc9a9f8c143752f3236dab5c4a6e441b6ed40dad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f4681e8a97903787d2bd6da7af38d9c0220bb0df2837a9e924610ad7d4b02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "383a183d34b87fff8306ad4d1b666a6ee933145d9125ef66b67652904c484a91"
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
