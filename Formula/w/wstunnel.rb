class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.2.4.tar.gz"
  sha256 "195014f728d2a18f822f481acf8cf29c8aa0669f6fe745a4f6823620e9b3242f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7e7cf208f9086bfb0d53be0e9421d2d8eb194c71f95fde3b74e2acff5b33927"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76264848263b4dd5bf7637bcc4ef9d4ca8de5cf62e2185fe649f99472f7804c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be8512ddb361fedb42ed0f3ec7839941c97e312fab092a38e177da60da4e158"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f05b2d93d86ba48d91e054c381e6e8c8d60935dfe15772134bdbaa400bb32bb"
    sha256 cellar: :any_skip_relocation, ventura:        "a1aab13045d7b25c239c52181451752296f188fc873a6330a671245ff79da6e7"
    sha256 cellar: :any_skip_relocation, monterey:       "a09bc884c0ba624276daa7026646b85420f599417b5a1a7cd95639197995dd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "188cb2784bf9c00b5244c68a6b839c72c8cbc375f1b6c8a034e13fcefcc24932"
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
