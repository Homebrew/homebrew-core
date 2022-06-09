class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "726ef9d6fed8af91d9d85c4b79829c201e2a8163acddc16ee34d198a63e9f38a"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b23415f3d1df5418d01ad2940957556c0215a027fb1b67b4b22bc45c60d6dbe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "618c875d2aa90ed47345d6950992762f69f22b5381359b5bc8f35885d9d486f9"
    sha256 cellar: :any_skip_relocation, monterey:       "588cd90875235a26c1a7761d3a667f892beef91ebbee4667ad34a5b88ffefbde"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa8091e23c6ef0157b7fb78c40a4f30c917ccae93eb078b045a2d1443cbd14f1"
    sha256 cellar: :any_skip_relocation, catalina:       "460fac72af6b066f2c5d1a68a5cc0ca8da60b75625db5a87b2cad73cfcf11f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c042c493dbd92d4c977f819584565d7dd7f0169921764480ec961a29a21512f0"
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
