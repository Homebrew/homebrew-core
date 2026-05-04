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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "143cd2bc3827f2856ef5cd9b8c5218b94c289a87b22b8304c646cf5a21d1adc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e91229084da71e8959f2f5e14935433ab5d3b4e9d23967a45946fa7c8606ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d23841a7eba8d27405ae69c878b736b91188a2f5ba894aaf2129523402b2dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b387b2b1c5bbce0fe2e65cefe0c60dda33835f1ce903cb5e93366c92c270221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b16c58e9da34987834606183da7f4e34dbcc324f9d932ed44c36f32ecb589a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045328be6c265b505a1b69a01a8e45d005003e9153a1ff1cc16966787d6b5dd5"
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
