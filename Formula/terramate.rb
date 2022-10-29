class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.39.tar.gz"
  sha256 "0713747f1baae7d8a7cb7a462c8aad5d4a797316dbc7bd9303f85d3f7b550320"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc16d6ff3b2680049a8068361edda80d1f361b8a5a38959cb8ed3a778d9cde6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e877830293bd7ea363bbe05e0acaad00b623a72a772ed4ae05bd64567e0040be"
    sha256 cellar: :any_skip_relocation, monterey:       "55b0817deba86fd5be4c9c76b0ff5908f5fae5e71b794ad7ba1adb88d0ac5932"
    sha256 cellar: :any_skip_relocation, big_sur:        "21efefdb17091d9204e70952fcfb10e2a6e1d525ddbfe130e0af15ecb3a62f49"
    sha256 cellar: :any_skip_relocation, catalina:       "8f6dfd35d6d1a6c1c4b5b080c3b97a9895cd0715040eb7b5d45ba922566c676f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb8002a2bfd619ee06d8df16681b1463e58c299d8df0402908cea675ac3518f"
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
