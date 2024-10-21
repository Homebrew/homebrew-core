class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.1.5.tar.gz"
  sha256 "18bf69a3e0b5c7f7fd4657a92788be12605c3f8e7c921796ad7cace170a3670b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f29dcbc3cf35a7aeac848bb8890b6dc7588ea424fbbd705098cbbd66d5e76ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338445ea4160d3d0f11a21171b1e87d3f429f2082e430b38d286ecf6dd95e718"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef527b58736a428ed1ba2411044659d002fb08ae4a6778e882379678d7acfcef"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef497504a704a38d355af04f5b7d3b8ef873819d0122c9f6b34aa6b6765f386f"
    sha256 cellar: :any_skip_relocation, ventura:       "44d1e0e384f1101688dbb44e632f55b0c47f6fdd258a52b55d9991ebbb95db50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc7dbf18f3edd84d2ec91e9658134cff0b2b8984d3fd66fbf3a65dc44352899"
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
