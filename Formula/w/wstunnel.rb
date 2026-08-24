class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.6.2.tar.gz"
  sha256 "3e4bb4169599ce83bdd64bc071b0435c58d9cf13b15d03693d0c962dbb5e8018"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cda8b2154dab52d8c19c1ab6de04214cccc0ac306b1dc26b9f787b9d841bf79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b442d1103e1761ae0d08ad4b6fa661b8dec92a1df14f50a70e39a3128935cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d498c11b305340088ee83832e277bf23a6933b4ea137758a7b21c06051395b"
    sha256 cellar: :any_skip_relocation, sonoma:        "770d1c74bfb0b303117a71fb8aaaabccbd3d24bdc3a34861a91e1eaa677a917d"
    sha256 cellar: :any,                 arm64_linux:   "eb6a88a824a7ad434f67655d33102ee1d9313db80d07768735281769539ed3d4"
    sha256 cellar: :any,                 x86_64_linux:  "2df2ff4f5b5d505a9276681017c2aa84dfc9cc2830431c7b75f2fbb8585d8239"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "wstunnel-cli")
  end

  test do
    port = free_port
    pid = spawn bin/"wstunnel", "server", "ws://[::]:#{port}", "--no-color"
    sleep 2

    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 400 Bad Request", output

    assert_match version.to_s, shell_output("#{bin}/wstunnel --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
