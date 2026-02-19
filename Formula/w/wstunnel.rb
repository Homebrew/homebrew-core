class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.5.2.tar.gz"
  sha256 "0e717c8330af19157e8a867bed782df460d80ba285530a9a17fabaf14e941d37"
  license "BSD-3-Clause"
  head "https://github.com/erebe/wstunnel.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "141b72c98cbb479eeedd22c041b3979c3449d2c28aba23b1b9ed48415baf675d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf6d75dc8b642812a9d74a029a41c834df17dba0a6f63607cde4e2cbe58ed49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e095e0aab8539b487053044512d102a40b20a15ce0b2913b52915ab81c70f387"
    sha256 cellar: :any_skip_relocation, sonoma:        "47c244b84ee2e21bcefd6c72911e22f5cddf252b5e4497e476b4d4e46c4e991e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4f1edb8d8b7d5a9bbefe2a289cd6f3065c3eaa2c882a3e8ec2d66ede2ea025f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6e9e2983fcc97b4edf37eaf5acba77c186e2483a939eab576a09dce30958c7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port
    pid = spawn bin/"wstunnel", "server", "ws://[::]:#{port}"
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
