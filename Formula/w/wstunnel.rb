class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "d1a009091179863d4d6dbde10f7bcfdcf2ce7b245a3accf27e09fa82752ab3c0"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acfa530cd8adae1d50819b39c24a80ca41b66fb213c795df341df1e97df533da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f45b2937165027102d6509ff86373fedbcb476610268834392bf7b132f3f2c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84fd27ac88fefca678fcf6a26df7e975e408045314c917ae5fb98a6f2c3a01b0"
    sha256 cellar: :any,                 arm64_linux:       "3c59cf0302127f0c2888a69c6de5528998765878d67a2946512c92e7cb48f20e"
    sha256 cellar: :any,                 x86_64_linux:      "e2994034518a75e0442cec91462084919d74df59f29572f677ae16bcf858c1c6"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
