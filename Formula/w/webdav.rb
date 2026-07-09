class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "8234159a648e303492f8bbd65af36345e3773893c8a7c13db17e5d62af3eaa17"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62848a1addf22379b15cced83d2ed0ad96f58168e4f17a319ad02c83c63a5769"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62848a1addf22379b15cced83d2ed0ad96f58168e4f17a319ad02c83c63a5769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62848a1addf22379b15cced83d2ed0ad96f58168e4f17a319ad02c83c63a5769"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae0e401ba94ce18baeedceb35e717193f03923d1a1809b36fd9293d3b9573ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67959a750c0dfeadc577741e8e456fff8528632547b4b042f6e25ac300936951"
    sha256 cellar: :any,                 x86_64_linux:  "5bcc72285a73d777ce2e5a8c230e10bb549e8445bc123964ef3aa6ba97271cdc"
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
