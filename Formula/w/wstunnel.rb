class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.1.10.tar.gz"
  sha256 "803bbc3274617ec67a141ae41488054d7edb103da8570a58b0134a5c68645ffe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d43db32e76da558e31cbab3c821af99266697b3d03f585dd187a38a69d6a8fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12d3ff58a25d1c5816977b40ada89386548d66104084bf4d367cbd544da19290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71bff9791b3ee5836a1560cdd2fb51b705304090487ea43a7d01a71182f69437"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e570fda1230df033ccc806cfe85f79e777df70632c26d8bf7a8d1899bf3a45f"
    sha256 cellar: :any_skip_relocation, ventura:       "8115aaa1afe4e839467ff98852edbd116d0349a5fb9ff7ddd9bebb19b597b921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53e0ccf0cdc0f20cc196b6b09c281360977e43fb8003bf2de4589e2b81e19db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83a428e4e123b08549d2712635350b46eea892cedc2686f1dd044cda44fe0afd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
  end

  test do
    ENV["NO_COLOR"] = "1"

    port = free_port

    pid = fork { exec bin/"wstunnel", "server", "ws://[::]:#{port}" }
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
