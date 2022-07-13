class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "4a011892f1c4389d32d3f99cfee7adfab5680c30c8e3a588eaf2cb0802872a2e"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da69c75670e183e671d18af142400badb4411ebc836423ddf3cdb1797b5aa34d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71930d84298fec06212202f64a31b34c0a0290b2940fe66062ddaa9bf58d683f"
    sha256 cellar: :any_skip_relocation, monterey:       "758e6c2164295a9e969f24a8cfaabdb6cbf67cc2c7d800e8ee91c0eec9c21573"
    sha256 cellar: :any_skip_relocation, big_sur:        "951e5359504a1a93d9c6a435af752615d2fb4b670d82183bacb9cc877a895ae8"
    sha256 cellar: :any_skip_relocation, catalina:       "d0b8f28f071952a3814d47fa27af07f80f992a980ebcd481454e1475ffda7f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6738c48c383f7de444e6cfa368bf4b21c16449bba002269b8e1e7f74dd5ba8"
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
