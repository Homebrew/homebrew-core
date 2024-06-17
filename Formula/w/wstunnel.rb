class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.7.0.tar.gz"
  sha256 "79864c549508adfe686ac84b98c930250f288aec85f3a35c9b4b3bfdf2ebad76"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a14a9631142338a0363b0345fec6d4b385f5c2d72f9341dafb47aed15234f5de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6162d363452399e451a874b014b15fc610ed7e2bc3f2c86531d8f846d23fa49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "726e2ef69166e117a86fa79cb7597f0a64a4674656a1883c14fdbad0cb3b84ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "739caa9981ad1ff36e7e6b9b4258e640818d161ad009fbe1efe95b5629cf97f8"
    sha256 cellar: :any_skip_relocation, ventura:        "61e16a13d9edf87a4a01155e2ab836424bdcf8262d991b282e71d92a310fb145"
    sha256 cellar: :any_skip_relocation, monterey:       "4825237ca3b0fc41d1a89697989ae9e0e554f57f15ec853f7cf8f63f672f2e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b58ba330a96ebbbf17f63c3c07fe0f2ddce3d2d37e7c680434676717cf15fcb"
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
