class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "11a7eb194a270dbee8ff4d3fc4a5926aeae685bf656d971a86ded93d6392568a"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2d4440035cd2670aabc86e8f1b28295d86dabbc42b690b99ad7fc22c7665d90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11fc7c2f64b12378f46f1e8c25a87d3d2349f6246a84ef43d82adb470b779170"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d72bf88b0af60bae66e03ce1055e43b2b9fc5b25c4742c3df84c6b1f4d9aae"
    sha256 cellar: :any_skip_relocation, big_sur:        "891c224f48dcf7c0d4dbeecec0087709bf10189c0142968f620df476b500254b"
    sha256 cellar: :any_skip_relocation, catalina:       "f68a587a9532820aadb914fb5bc68c42e11b27a0458c4d2f571924f74d57f2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b83b10447c08e436e058ccbea094872585ef706faed87ec5e712a9f24ebbf88"
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
