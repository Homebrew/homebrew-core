class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "9eae471db9c5551675fa1a4e5effceccf52c78d463c37ffdd472fb81e15b0485"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589f20df13b7b82530f784c91815baf206a7dd8cfce0378d4f191bfdf9460954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "589f20df13b7b82530f784c91815baf206a7dd8cfce0378d4f191bfdf9460954"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "589f20df13b7b82530f784c91815baf206a7dd8cfce0378d4f191bfdf9460954"
    sha256 cellar: :any_skip_relocation, ventura:        "37354f3eb14e787f8a70e3d999c6f98d6b3f8195f4442022f07d5f4f1dd72468"
    sha256 cellar: :any_skip_relocation, monterey:       "37354f3eb14e787f8a70e3d999c6f98d6b3f8195f4442022f07d5f4f1dd72468"
    sha256 cellar: :any_skip_relocation, big_sur:        "37354f3eb14e787f8a70e3d999c6f98d6b3f8195f4442022f07d5f4f1dd72468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9df611235f1be698db0933965895c761ddde1c9735358839fad58376a9c10c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
