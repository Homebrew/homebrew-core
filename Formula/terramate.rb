class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "331b794d6e41cf1ec648b1b02a522e82893c6f8e26e54c63cc9e7d8c1d78cd3f"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e581d9a2eb59fd934af73547113c0e6cc25b65e03afacd4ecd88703546caa8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bef1a8a12010f692dd70bc289fa46138a62d5fe4e636ffaf74a26ffbc6330ed4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3662c41304dfe055035fc70c3c65fabda1417fb28c3ba7dcd68e08a272d0f536"
    sha256 cellar: :any_skip_relocation, ventura:        "1a107c238fcfcf4294cd5103e0fc79b7341f756bcaa5755561100c71b5241530"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1e8df925c2e8ec03390a9dad50dc9b5df1626e6d28cda172247e9113aa209d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0af335ca067eee289f501f0c858a2e07f454bb211c6a33792b59caca25c3dc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1747f40fb7b835fc3cefcc6e32bf090fdb758fae7869a05c45062680782254ab"
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
