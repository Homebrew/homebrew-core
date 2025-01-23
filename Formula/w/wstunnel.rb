class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.1.8.tar.gz"
  sha256 "6717e361d5810349cdc30e3ce78e0883bdad3c55c228a7684dc5dff856419124"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d35a17e14c659598372b96ec3c06738660a8a4f5636e6a324d03dc6b52d74a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c46f5f954e97600bcf68997959afaf02b10eb4db1cec5a572866c9dcd1a8d12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7fac097e3cd65ca378b9fc577de4813e16a52c2de5fcc3cf604141c4e6fdfc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f05f254c38853f73b00625898a3ec38c6fb26bedcd0e73aa5119d3f7a251518"
    sha256 cellar: :any_skip_relocation, ventura:       "0e0fec3f45d242274923fb2003e5085d5105c6a541c1ba1c6734f848e775ffce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf4ffe3d57264b3e3e9bc628fd57cbc8395c1d03516c5b492ee282ed85cef37"
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
