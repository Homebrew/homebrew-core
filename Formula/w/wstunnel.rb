class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.4.1.tar.gz"
  sha256 "4362bb70883404f6ab78a82c862be3542718cca711807ad0d86acec629615b3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d4f5e300c938105d0ad799c0d2daf238761efa397e04b05414be129ebdff431"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120c5ab886a482e6e947feae3373ea43b790cb179d45402d4738e06d3ae75848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb620f4c5ff167c888bf88c0d99e4f0a2665be4f3e32f4558994e5eb777814b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd4efc545dfb891849ec17e25d5126eb774bcdd1841e501c1da84b29f4c08dfe"
    sha256 cellar: :any_skip_relocation, ventura:        "b6c53e708e3972af7f3623484b8f4be08170a6fd4990a819f1b5e2585386c3ef"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b700ecc97c527495d10b7ab7d858f234362bd20dadc251a20c1b658fbe75b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6c06a8e09a81e8e0a9943d72f0201708ab09dba98e89687b4eebd8d2bce0a9"
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
