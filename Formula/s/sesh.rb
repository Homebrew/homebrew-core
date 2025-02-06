class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "ced5e642b6c85782aa6f0e718fa90b2732f553d311bf9e5584a77ef34c0aa1be"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ddf6a196c33756c65194c9522f9caff1b02fd8451c1cfa652ac531fb8e1d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ddf6a196c33756c65194c9522f9caff1b02fd8451c1cfa652ac531fb8e1d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44ddf6a196c33756c65194c9522f9caff1b02fd8451c1cfa652ac531fb8e1d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fbb9fa4b2e79930fb0c4ae415de1e63eb4b55b0f02f91f90266270986e26d16"
    sha256 cellar: :any_skip_relocation, ventura:       "2fbb9fa4b2e79930fb0c4ae415de1e63eb4b55b0f02f91f90266270986e26d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1055fecc334ffb0d88f57cdecaad049ce6d4f0ea52c50e47770e9de67c7ec0"
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
