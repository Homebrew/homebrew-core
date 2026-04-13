class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.5.tar.gz"
  sha256 "7be1082c077375980b93a46ed4de37c64254203a211723a83b9b43d7a064e865"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34bf91d38c4e95e3a0501cb8d5aa76ba898733319d263e320f17e5e87b819406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34bf91d38c4e95e3a0501cb8d5aa76ba898733319d263e320f17e5e87b819406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34bf91d38c4e95e3a0501cb8d5aa76ba898733319d263e320f17e5e87b819406"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceba1f28623709f9668af4377e5e7a363280c9afdaed535134b3ef87e4179c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3b949c1a3b1b81175a3ffb4b5bdbcb289910019201dbf1f268220011e126eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d380c65bdc3de3ee410b588fb2461a95e26350784399cec12f5fc3d5bf0cd0c6"
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
