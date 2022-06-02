class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "b18dc79b67fe026f2bf8ed9876770745cc2d8cc7d35001a13f4f71322ce79ef7"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c7d31f436a663229209c5b9cda16c332bc385606d3bf00af8b1112cfa1b52e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2146ef69d2406ab1b3c2f84385e31cde6ea7481d53a5f45aca0fd9b07cda7ee"
    sha256 cellar: :any_skip_relocation, monterey:       "2d83ad9bef21ab1b3ce797fbfa9d4bcf37e49fb390eb3d20b467e83d9660c7fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ea28fd1faf6cf415c2ab8a613dcc5ac6068ca7e0805d9893cfed8ae9f985ecd"
    sha256 cellar: :any_skip_relocation, catalina:       "d8f8c9fd6401b1e3897c080eb0f8fabd6536086e5b10ed0cfc7dde0bf569755a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad42c43a5a3dbc4a5cc631d5a2a59b5720219877589769e01bbd8b162f7ef35"
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
