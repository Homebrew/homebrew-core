class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "8ef3dcff638943b4bb48912a82bc298a61ee3ffc0e0caabb5927f34af2a30ce4"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8540f5b75a7f527cb1f4d1a513fff08e6831667e65ebd1100a05ae17b1a0a330"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "305abd93bffec640d77efd449c44b320ca70cc8488c6b00076454760cfd03800"
    sha256 cellar: :any_skip_relocation, monterey:       "02ca745c49e49dae2a98726c0e34c68682b08d0f1ffbc13321e4b67e9d0b2716"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9c852797909655e30e20e60b29e6d115377f6f5dfe846c5244fb61e93edd683"
    sha256 cellar: :any_skip_relocation, catalina:       "bc166ee6f7c7e07985c924d18a3c003cb6674f7f90959d260636b5fd5db1bc4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d017ed450b437359aa34740abf09cd5d07a3984ff543bd187449af1581d31eda"
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
