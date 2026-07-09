class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.6.1.tar.gz"
  sha256 "6064a5b94af4c75a193a914d4d57ec367f904bb7ee1581824c9cced7e06d1aea"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f0ce1db2fe4e4a2eea1069817dac5aedae6b8a7726acda12dfc3f9b74665bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97bcd624b50a3f41b280fdffe0c402349e22926759287c5a60fdbf2b998ef51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1d01c1d51d807ba2b5ab5c15ab48c8bf797bef9dbd85fed0be744cfa70fe449"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbc03856201009a05f1291f01c80556a770ec4c5682e1c48d949a654a20cfaa8"
    sha256 cellar: :any,                 arm64_linux:   "df1cb7367c6e7056dfa2dc168c93c1b4e4f94b97d1123f625c91a875779253d8"
    sha256 cellar: :any,                 x86_64_linux:  "c2baf81ed545ed23e1bf144555c8583fb5f1e933dd56f4ae5ee74ea98c57cff9"
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
