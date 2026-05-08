class Webdav < Formula
  desc "Simple and standalone WebDAV server"
  homepage "https://github.com/hacdias/webdav"
  url "https://github.com/hacdias/webdav/archive/refs/tags/v5.11.8.tar.gz"
  sha256 "56f63ff460a4ab1b73511a39dd387edcd5ed124acb9fce9ae0c7057eaf681bd5"
  license "MIT"
  head "https://github.com/hacdias/webdav.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db5fc8850649726ca12734aeb4ab054b08b50af025b2ab645c36fa8ec9939b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db5fc8850649726ca12734aeb4ab054b08b50af025b2ab645c36fa8ec9939b91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db5fc8850649726ca12734aeb4ab054b08b50af025b2ab645c36fa8ec9939b91"
    sha256 cellar: :any_skip_relocation, sonoma:        "373dda8614aab14964f48b45ca21652ddc9bfe194fea7cdeff28508906600d84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f341a86db21832867785ecb35d3c4c0475888c29885c091aa469b14e5de452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249eb07bc788145688f9b36c638a754b8f82ecc2fd06eeb758e27a4238bdebce"
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
