class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.10.tar.gz"
  sha256 "522e146e9a999490bbea5cb7dd3fefcf455fd17d0a39561501cbeab1de037adb"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf493a21e682ed75b9b76fccedf0f6ed305afef430590c324b93615dca1a247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccf493a21e682ed75b9b76fccedf0f6ed305afef430590c324b93615dca1a247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccf493a21e682ed75b9b76fccedf0f6ed305afef430590c324b93615dca1a247"
    sha256 cellar: :any_skip_relocation, sonoma:        "0524071370da22061fb3680bdafca593bcad724cb7b1a5ad56ed084b18d09ad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e49795423f068716edb7581833620d16086044cb56896853fcb3f834b8b69b"
    sha256 cellar: :any,                 x86_64_linux:  "53d62e8484a7fd4135d129e883a44ab71bb0107ddf2ffde9f2574e0126abe6c8"
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
