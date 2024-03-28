class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.2.5.tar.gz"
  sha256 "5ad84a9e888539a63e81df4a7e8702e228b7e0fc5a51777bdb45ec0ebe36140d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa01ba1050fc6031cf690d6bbb6775f137e19c36b9aba3930b996c9d05cad007"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b2742c9c2e38652aa3874564a49e3263fc4bc7bd6d6ded842cb1fc94c8a745"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9454ff75e7f95ef01efb2a4fc22ba02723057eb687da9bf726a284353017ea7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7b1b079f741faaab9901e44b14c9038b7ab7432f1ced7d269c964547cc4d55f"
    sha256 cellar: :any_skip_relocation, ventura:        "3438dd959930ffff9fb0e6a101f40cba88294a1a67aa1e2835a11b582a96f4d1"
    sha256 cellar: :any_skip_relocation, monterey:       "83df696d453c684637fe77a3f72d8dd873fb015a066201ddf82a259b349fe76c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e5c754b981e93998179a29b2d1d0d11d899c53d0297e1e8baac714144ba251"
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
