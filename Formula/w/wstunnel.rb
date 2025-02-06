class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.1.9.tar.gz"
  sha256 "b14e2c96d80753d2031d66d3766c3c91b27f38bcf41842419f6924921dee1d92"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8de0efba4876f257a2cabf76bd837dab08812134282af84b585121325e9d01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "881f53c4e6529f20cffe8ce5272584291e159ef25cff71ed6d12bb5f030376a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1202f4d8481e4d1a08075258c3f3c2bd511c3cb521e43b47bb2bfff8d6b83c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c39609f8124a59552c44fb4a2d174f72e1d3de829b4e4d28411fbffb75bc149"
    sha256 cellar: :any_skip_relocation, ventura:       "1ec14ecee6e9f0abeffc68410d823e4c73ad8c34ad114072c9b11d47d1ea05ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c4c4ae1ea94c9241d774a6058aa14eced8521ba7e6e80d467eef5e261f544d"
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
