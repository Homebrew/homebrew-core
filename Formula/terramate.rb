class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "1b9a57af1f717be1bf6b93a7a6415eb3477614c219689e13ee87b38f85563353"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59479f765cad5dea3c8dd8e3b110d2bce5cf6002f37c8dd097608e2e4862d5a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21a2eb82c11fd2913ad02044c0631403074bdfc4db73c0f7153f0642b077893f"
    sha256 cellar: :any_skip_relocation, monterey:       "3a9ae2a2c8c6b83f580890f596a87125192b932a08509283063814a3188c429a"
    sha256 cellar: :any_skip_relocation, big_sur:        "12f628df87db5d972ecfb83c318fd4d30d5fe5f51f2a60925da77233f0065999"
    sha256 cellar: :any_skip_relocation, catalina:       "cd4fc87b564d043a7e5d0fbe05b82f03d01c23c7f64d2642ed7eb8b468f1fb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dded74a3222f62681ab182c421abc8f4b2a1af37b7f6e11cc9d819e5d022893"
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
