class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "7e36326f7308e7248695e87ba19734426edbbb6df7496bf4afa699fdcdc343e3"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5b5deb0b24a0b461877e75d71699a251e4c9edfe793d3debe304b909da47ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5b5deb0b24a0b461877e75d71699a251e4c9edfe793d3debe304b909da47ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b5b5deb0b24a0b461877e75d71699a251e4c9edfe793d3debe304b909da47ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b711fd7a594f0ae6d1eb842861b3ec3f3d049d58b2ba93f1d89c9fba761620ea"
    sha256 cellar: :any_skip_relocation, ventura:       "b711fd7a594f0ae6d1eb842861b3ec3f3d049d58b2ba93f1d89c9fba761620ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f294a2c5824dc00631e7bc0f943743fcd034e580536eb279ed242821c651d9"
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
