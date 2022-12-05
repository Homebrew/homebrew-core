class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "08cd7641e477ec6c7d1a5232a17e5e87ad7537d0a84d72ab7acee72ad6895edc"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6a4295704f0b58deed002f7e5e62151e6e7a8cf061ce8454fb6e0bfca4fa506"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "205f58b855e11d60b1f661f12dcfea48240cbdf4fcdecc2936c8c8f1e5bbd635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3396ac731378bc55c7fe5d97f555551a7e7691953475560859e349f54101901"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf2240e9706c80a3fe6d31198a1407cdf052a3d078b96975b84a1f677a52da7"
    sha256 cellar: :any_skip_relocation, monterey:       "4e990b05c71591526e50a98c2d644209305a5c7171fa18500ea6cb4cfd28757c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5560e18a449a95c44f9cfca36d22e24d9ff98d65ade8a8b0afcf652c32f5ced1"
    sha256 cellar: :any_skip_relocation, catalina:       "c1fda258c453193b6112d25b55e82a3cf0839fa2748e9dcb096295c21550ab62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b18d60a22f82c7c0c38f9e5fec81d7e0d3b04d9a4129c5763c8553653e0a41"
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
