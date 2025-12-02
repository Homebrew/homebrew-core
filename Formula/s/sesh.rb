class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "032032a79e65bafc24c6e4752100caae645b0771b2f1ef35d1c4a97079ac952a"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6d91317180d7e8647871bafe80b7de42bbda859a044734ec9a0636246a4b7e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6d91317180d7e8647871bafe80b7de42bbda859a044734ec9a0636246a4b7e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6d91317180d7e8647871bafe80b7de42bbda859a044734ec9a0636246a4b7e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "94fcbd0005046fb83f0680a7f9348880fef020ece6efd862a844b2a5e19e10bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "551b431abf59abc9f9c0a67ea6d449a814775530928627693a33f96267bc3f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebee4c5a06c8522f4090d9929643eb95fdacb1846edb39c2884d12aa17ac6d72"
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
