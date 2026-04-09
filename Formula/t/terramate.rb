class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "a34cad12ae1dd4e6f44e14dc649343bb36fc0a76cf5e903905161e402333c012"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05c85ea7a7237e5f3c23a4ade0fdba3fca893b4853a24c332aff42f7b0f6d4cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c85ea7a7237e5f3c23a4ade0fdba3fca893b4853a24c332aff42f7b0f6d4cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c85ea7a7237e5f3c23a4ade0fdba3fca893b4853a24c332aff42f7b0f6d4cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ff912ba808b068f5682ac8b1f07850b1fb01d0e98407a436f39a9f3bf5ec732"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24064d9cb71e9b10fbb2ea9446c91fb0146d4c489ff14c4e50ab4ab5a913882d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73f470f48a43f23f66a6923de64b743fc44c6364fe9ad8d33b92e80bf2ad2ec"
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
