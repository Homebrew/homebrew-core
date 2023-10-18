class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "14204c7f4e0b071c38b7a61de711847c86ffa33f57a0813a7e801793884a0545"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef240135a5562aeb071e50ed4f3b75f7fe1806a85b3ec51fa0147652a5079ecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7291e643b3abf9f1f9e1c7e66db1c8d312abffe4bad18b7a754b385621888a21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0a4bd223b8e5a443f7bb4933b095c4d1b3509b948fc6d8dcbcfbd4fec0146b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7299880d3003fcb4a27a00d56a633ee8b6ad0cd8260c7aa8e21e92a498a6c0f"
    sha256 cellar: :any_skip_relocation, ventura:        "e2a839bbcd9628316561ad27bad72ee364d2acc4a71de76834c40bfa7b45d490"
    sha256 cellar: :any_skip_relocation, monterey:       "7a00523dcc5eda748f754b56c947f039e561eb93db959511dd05e7709a1e2b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a21197a3921b58db0f923c0b1d61118b5728fbe955e71b5c90d3db3f5561e3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "Project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
