class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.4.3.tar.gz"
  sha256 "f68c4046b117ad8fe4e63c3963a8ef9236ddc8293a3dabf9e7033ffb4862f4ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16320c67ddf58a559057e90430ba8c8234f1d9c664e331f8b3883e5482714fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "441c404c0eef6847048e6662f4c793f50f5ff51a8a7230e8695c8994b4fdd040"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "932f97e334cba8f1261ee541b364344ac20cff8dc16213fe850c5721406d885b"
    sha256 cellar: :any_skip_relocation, sonoma:        "09e4c693346079381fba212a16e63b4ea73ea9954b97038f0ac3693b838cba9e"
    sha256 cellar: :any_skip_relocation, ventura:       "e5c7ef6c11cbffc723478c0b6c993fe1c4b7659b1929e2861b62bc40314f38d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1bb0c23bf6b0e3637806577c1d094f2be93ebc6a6e93e31cb0dab7f74306ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e289beebb447e7aa41b2eed8c1ab4cae7ae6440a2aef2842940a27f140202fd"
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
