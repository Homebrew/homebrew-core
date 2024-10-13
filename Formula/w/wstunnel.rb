class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.1.4.tar.gz"
  sha256 "92120fcda8d81df74d4017f37623440ee2508d63d8491a853871f7fd51461101"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a93669882d3862fb3281f09e3bb9c0c3d28fc3dedf1c7e6dffd99bd4b2ed867d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cfdc955386c2b791bddb16d3f3361e3d5ec73877fed3678f9805b06104f6c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86f35f131a7ff4840f61002d48031e2b57e125954e663a851d178aef9cc18cec"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e95b7d412e7fe9214a6ca4770ce181bc2fd5bfff07ed05377756ca6961d1a9"
    sha256 cellar: :any_skip_relocation, ventura:       "a0aeccf82afffcf6919f4937d61eb22c5352c29c66a9f9340708b6d548479b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98eab59c39509b0c8dbd4200b781cb1710c0293e8fc4d70ba1ac492ba6f61c0b"
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
