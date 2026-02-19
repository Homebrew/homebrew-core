class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "827f269d3dc564de13f995d983b4c714dc8937de2308243a55d80a2958169273"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ca4b827e0c3f944c3365bb49de47c0ac9a62bcefd10c4eba40d5ec290e66c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31ca4b827e0c3f944c3365bb49de47c0ac9a62bcefd10c4eba40d5ec290e66c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31ca4b827e0c3f944c3365bb49de47c0ac9a62bcefd10c4eba40d5ec290e66c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "937fd552cbb1a556965301d894dfdd770e4a4aff0be24173f5e7a45b55a53f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "296dcba6e9f6330031458c7e6ed49942d90cb214fb0e4221eb973f7f8fa2b1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ec201641092ca72a59b3c291766ba7d59006f8509fa12678e2ca085a24a22c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
