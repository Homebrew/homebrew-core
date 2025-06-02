class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.4.0.tar.gz"
  sha256 "6a01bb7e64858161648b166bb1324423c375a1f293d6bb7b578fe12f7f33b7e6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7131fd10b8c0370f8df4f48360e78325b43eff264e949e7b087a34cce655ce7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3909fc9c042b0044860caf327096792f1233d3d7557a2cba7138ebcf1cc2e859"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1c0342902ef13493ffa8555667fcd5e8ba2b6b1aae2b1b089c630e26d0e6667"
    sha256 cellar: :any_skip_relocation, sonoma:        "75efbd1d9768439c6abe5be8e78d8bdae64d5a13db4ffd2beae880d6699ecc7a"
    sha256 cellar: :any_skip_relocation, ventura:       "4bd52aa6e76d7660a77103773ee0cc8955212717f874b13f2e0104fb28cd6128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "424fe2480eb9a27edd551debd986f05a6a35fce28552d9b8adbf9cfaef756fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb85da343f7a1b2f8d9e066ebdbff4956c4f0a550c260be334dfef99d42d7ad"
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
