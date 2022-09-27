class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "e03fe8c4a7c50902497b3164a1afe4a6a6f0ebc5b781b1463f30f866fd6c266f"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f3778183c2241d6db439fdce4ffef8d921e323ab83b1116318f35e69456c4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80979dcf87b1b250492faaecd38c48097cd3620a7261b52cbaab4234038eb2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b20df685af8ea6b1f405e1fd3f7d657ffcdb803e356f4d58d6a84f48f2a2f69d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ca62926bf2cb5fa176366db52ba540aac35f5a897cfa7395e85041ae071920e"
    sha256 cellar: :any_skip_relocation, catalina:       "40f568139c52cc8830116bac3e88ac689cc0089a886a48860820cb4ff470566c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a1b480b1d126c92972b9a9107916baf06f46d0d40c654d32803051f91379636"
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
