class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.5.1.tar.gz"
  sha256 "cf600e97ec15d243be6f32f5418ff48ab59f0714258f18f7dc7b95759847a9d7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab7190201f060d11de780cda36b91b0ace5950634399fb6634b450b64de6d415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76a5499f57cb5ac2023dae70588d0a6f7fcdae86efaff081fdc538dcf4e3b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b9ff8214ef7c413ae0f5db5b8ebb6e52a09fa1c3f1ef56488f6850631ba498"
    sha256 cellar: :any_skip_relocation, sonoma:        "85605f84293ae6aa8bced12498bb1e39657f3806277995860e85640ff611aa3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e6f8131a114999a9d076be97c6c1a4d7e2a0d7658d8781fb0f260499914f971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc95355e6acf30c7ca2acd7041a39a62937a6d7c79d6e4a062fdebb4c9f1d491"
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
