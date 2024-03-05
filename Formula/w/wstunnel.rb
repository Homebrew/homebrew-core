class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.2.3.tar.gz"
  sha256 "d747fcefc892513b195ab8227ed1c853e9d95966c87bb08dbc01211982fecb83"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "927f96da7e98774e30ba1c9733a508a8326af5434238823301c4feb82ed0e28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b9b01db399833bf3e9895ccf3b9e822b6d5d78065166040e42a489e53c2896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493679b430bb00611c8faf3e211f29afb3194281f1abeb3e6917eb2da788a2ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "20d80d17752335f5ab3a04143c88e41bc4579d2216fa067109dd4928736877df"
    sha256 cellar: :any_skip_relocation, ventura:        "9a90431041a7832500aaf28303993edda3027f879b145b9dcb6bac280a3cd0c7"
    sha256 cellar: :any_skip_relocation, monterey:       "008dd09214a75431ad56a848569769c2b7d7c73dffc164e2302ab7adce3be558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8a722038a3a1722817d4cc55f19dec7f93005bd3bebba816c07ccf31c68c22d"
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
