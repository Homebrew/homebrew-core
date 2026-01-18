class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "870bc37bc197bf2771a605d3d3aec5894cd98d345db58446f2dc60f031273370"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b348062a8b290c939603e63dcf8056598d206eaa49e06c7b91df85e3cfa2297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b348062a8b290c939603e63dcf8056598d206eaa49e06c7b91df85e3cfa2297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b348062a8b290c939603e63dcf8056598d206eaa49e06c7b91df85e3cfa2297"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ac08abda657362f6b69288ff1ea02361fca860bc533c7c3157df8cc6b2c00b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "529ef42c9c44e5c82c9bcd7eea3e587276fe2ef58846f0c47f4d99571762dc48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ec988d9d46eba84eb1500ea8fba14ed9b0414f0c5eeb199d1d2a202bcaac95"
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
