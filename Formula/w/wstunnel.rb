class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "22bf740c8411c0eb9d023c381de131b77ec193dace152bcf6016c2e829dbfe4d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36053d6190aef535927293aec893de6da7fcdb21c06ff02b86de4a55255d65cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dbdf329b98d88f4a5bdad4fc8e09c1d38da2026fbf743e2a3b151441557aa4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f46a4aeaf2f8893c73093bbd0f373e729a07c6cf65b2eb5d739c69b40640903"
    sha256 cellar: :any_skip_relocation, sonoma:         "98277256a4ace4aee3f5fa213437b0ec804caca4c34a1e7e62e6ff15e38d8f72"
    sha256 cellar: :any_skip_relocation, ventura:        "927e86b33376251d6c7a6b471ac46ffa361128a3716a0161cdc5dbf97977f41d"
    sha256 cellar: :any_skip_relocation, monterey:       "699bad85c31af53877d64de2c00be43bf2faaa7fe9a2fd0a4eb57002bad5c086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b0f52b0a1f2b2b51ae7cfe3d5b72284eb89824fb931f970f5bb3add2ad567c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
