class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.5.4.tar.gz"
  sha256 "1815b64a47114e4d7449bcb76e292a07c0e3a3cae53be14345ebb64ebad3e3b4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "149f155cce2355795232b0ccf7395ba538fcb1d3b895d5980a3cd12d6e19c644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a789b71a93030758472c8c674116cae1169efa9d679325b8b65c3420c948866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cefa0a3f08582ca07f7dd8b78605178babc34367b1d2c351aca781d6b9c4f00c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7520bfa92de43772941f426efeec1f35eb1b29a6bc89f94cbf42f17418e7f60c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03b1144c7abe7ec993a49daff07241095365eb9d0a1c4e708ab30ee009fdb85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6553b0cf984b4279f5fae9ea9dff9fa307121844ff90d8dcbe97968916d4302"
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
