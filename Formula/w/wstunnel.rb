class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  license "BSD-3-Clause"
  head "https://github.com/erebe/wstunnel.git", branch: "main"

  stable do
    url "https://github.com/erebe/wstunnel/archive/refs/tags/v11.1.0.tar.gz"
    sha256 "3471bfb3c6605deb5f9e1cbdab88cca638c2e31f849c03340b02156ca3ae39e2"

    # Regenerate `Cargo.lock` file
    patch do
      url "https://github.com/erebe/wstunnel/commit/adc9e7dd99a67a817034240626d2ffdbb160397a.patch?full_index=1"
      sha256 "9e8a1554e278e4845e09f25df82b395758096d9f858a394d5280d3f9d529ff39"
      type :backport
    end
  end

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ed0d1a5201420840792e9783d0d5e9765c929956f591df239111b2218dd0653"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "570bf22be19dd4d14d7d0301a44f953ae87a3f3b22df7d94c1df74b497befaf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64b16590434589f635c677fe585f35d649726b4cb46610d8f1cfc20fd6ca5def"
    sha256 cellar: :any,                 arm64_linux:       "b96e721da06b06409d9bee0f7a426830872e8b34f0e01665e68578f0f57b0649"
    sha256 cellar: :any,                 x86_64_linux:      "d74adc0f531a0a8388213f949375683f2e44fff775b3ccbcca063b3958624326"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
  end

  test do
    port = free_port
    pid = spawn bin/"wstunnel", "server", "ws://[::]:#{port}", "--no-color"
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
