class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.6.2.tar.gz"
  sha256 "e18106642be7833e88875281e4e7e53d9c9df84ee3416cd5ed4fe1cf04aa8e37"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "708138571eb04b209780e7eb1567a66400552a17e205b72233d367f375ba3303"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57fc194602fcdebfe4b4789416ce652148558dac8772250eb8d0b7a67e00d5d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e97e42635e128405b506972d513e6555d8047947a4bf8ea917919f958430f09b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4d2698724266ad87ccd29e85f24429d2b9a855a9aa8b824fc2c4a8e7ba5b836"
    sha256 cellar: :any_skip_relocation, ventura:        "395da0cdfc22af0aa81ad2801e8b030c7ecd32b6a3eff7e0c20ba18f59481cd1"
    sha256 cellar: :any_skip_relocation, monterey:       "589fbacf6edd832effde56c5927028a5d06ded3956d02b903729087cbfc50c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d738c525f1154b0b7640d538de01a84dc29f311c18f7fbe547b3fb80d93734"
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
