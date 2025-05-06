class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.1.11.tar.gz"
  sha256 "a560268d5aa1f8dac9c158798828c495c4d266ce5953891494868d4647e36cac"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26a541261c8e7a15e54f8947d3aae6f4ba3389e752d79cbee12e9c48f1b47c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f653a89edf804bfda5647b1c4041f6354ae441a54dc731ecc6f326013506b660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a255e81118bdff2150be5b916d64d514f62565aaee0723543ac74ef213f423d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "05e79f69fa7727cd7eab0356a7e8222b31f9e6725fb82bc2ab82608a8deda219"
    sha256 cellar: :any_skip_relocation, ventura:       "3c5a6e0c9c4525265e6f958b8d0ab6cf540c521cd4733bcdff94e6f091eae27d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "521aa631302b5abc8ec5650c6226eacfc1b902e58b02653c7e2668245d79bd63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcef7c221dd3185f7e83e988e6edadb6bba4b8480a23d26e7e08cb65d7fc0387"
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
