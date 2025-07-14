class Wstunnel < Formula
  desc "Tunnel all your traffic over Websocket or HTTP2"
  homepage "https://github.com/erebe/wstunnel"
  url "https://github.com/erebe/wstunnel/archive/refs/tags/v10.4.4.tar.gz"
  sha256 "69a12b8bbc2888dcefc84a90fbdf9925c7292e3b2839108a8aa1caf4a6758ffb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17b8c9207c050bb95f2ac59bd4da3f66c4a45e7349c95a095036e4849dfdad49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02f2dc9c9ad065763abe9d88edb73011f5c69dc226207500a59f0543b19a704"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f81b8f904e262150dc08ea3f7a70a429469137b3e05408580b564ce51258a07"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a525d20666f0c554451493bb56485f7180dea7d699de9b3e9e92711905f3ed5"
    sha256 cellar: :any_skip_relocation, ventura:       "e7cc97543f71a3629bb9a925f9ea35cbbed08f38401afb90dfaee3ceab3652ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e703956c9cb7e510f0f217a6f0cea26f63ee5393e9b739627bb3c4c1d29ba611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2be586f0b41896c0b23e0691e0a0adb586a5dc3e0c99d46285715a56dfa0a291"
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
