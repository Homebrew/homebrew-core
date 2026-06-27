class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.7.tar.gz"
  sha256 "2bc33866fa53eea70e647aff200b71e7f07f8bba5c679c14a1749e3dc6a4d882"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa589e09635d1b89e99eee19ee6b0ec0e1e7635d24d6fb3d40c254a0ae09b213"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965cd7216979d1ba9a015539cf9aa017ad012fda0140352c64166e011b538573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af8395a4d0a97f93fc0b5a83fe958c100683b90ea1980cd6cd5ffa675b42ae38"
    sha256 cellar: :any_skip_relocation, sonoma:        "88407f032eb54a1d49f18c07eee6aae6391f4bcc2424ade4664089826876ed88"
    sha256 cellar: :any,                 arm64_linux:   "8d2108dcda0181b85a6dd93e482d4c108ee7c1e449b20a1f4e9a78fab78c673f"
    sha256 cellar: :any,                 x86_64_linux:  "5832c6943fa5c254ddaa81762a130cd150ab83a847ad61d56908f934479a9573"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
