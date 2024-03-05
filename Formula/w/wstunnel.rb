class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v9.2.3.tar.gz"
  sha256 "d747fcefc892513b195ab8227ed1c853e9d95966c87bb08dbc01211982fecb83"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8ddedf50965e36e40346ffd7f765e02b8d90fb4b0645b15be8395dcc011df6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2c75931b8270ab0624ed9e5b5118078cc6d004bb604ac465c71c5a1edf178bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0dd5de33166789ceacf17a07a404aa1ec8ca793d5b7732609c8372ef21cf633"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6800c284772fd5e42111528b99c4ca63220f035c9fecab7a625972ca5e5b828"
    sha256 cellar: :any_skip_relocation, ventura:        "2d551b9a6fe15dd710d126804028ebaca16cecd7c764a9dc8670d7276139172f"
    sha256 cellar: :any_skip_relocation, monterey:       "69eecbb31dd4dadbb0a682075d15eb47f5529ae4c4d05173e581ad26750dfe5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb84f1303f45e3f79e5f07688a356a30dfda26816fa4da5fb40716bb519315bd"
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
