class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "a63b312a0b6788b596119358bf0b18ff58f3145ff2bde5164077cfcacfe9b8d9"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3be6877a6c92382c42f737b1bb1ebd80f9452c2952cf48064f29f5037d0c363b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be6877a6c92382c42f737b1bb1ebd80f9452c2952cf48064f29f5037d0c363b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be6877a6c92382c42f737b1bb1ebd80f9452c2952cf48064f29f5037d0c363b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cdde1b366f3b8ce20e98aac648821fef34b468de878b2516a8a6e325add1170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0330efd8ebab02c27a45256d9b391fb2b27e4d6e47d085f2d08b9961117c0c5b"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
