class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "43110dcc20b91996a12dab3424f7685c029d6700d99bc497b889dac355c72dbb"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abaa8dcb5a27baebca7a336171fa2b976206e7c07724d1b8387ef8e1b24cba60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abaa8dcb5a27baebca7a336171fa2b976206e7c07724d1b8387ef8e1b24cba60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abaa8dcb5a27baebca7a336171fa2b976206e7c07724d1b8387ef8e1b24cba60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b042c6c917b5b4e28efad77963f1dc377a10446e7135debbc491098ac47a3b7"
    sha256 cellar: :any,                 x86_64_linux:      "664573abbcd6509a7803e28dbc77f5b06a481c58891ce68e08a066c04b30c255"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
