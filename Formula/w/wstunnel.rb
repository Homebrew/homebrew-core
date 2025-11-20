class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.5.0.tar.gz"
  sha256 "e83a4fe2fe17f7e26098b95bbb5d0efa5c02e6fc6f951aa14e697bb7698e683e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9d492ce7eb4cb8dda20f66e8e18f53e8da3ac05800cc4ffcb466b0df18dae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e49a22b39aea2e1193b977b301b672917e49e4beaa2a28554b93c357c1a9fd94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e3855c7b63768eb29937779fd29b20d11f20a28ceb146db3c49e8d2914c8fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "96bf0f007cf659ae1318e4df7a375add8f9105089571d29abc96a256d33c8f15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bab1f0247a0fe4c34704921aad7f094e02ba6c42d1e9177bad9d2ac28b24e75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ec47b615d818dc32837c7955940d76e2079c5a253a1c3a67b639943071a56d"
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
