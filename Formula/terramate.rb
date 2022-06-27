class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "1b11e1827974a6424cbccae8350321e12ef04697c228696939f5f256a9990bb0"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28134a981c6b8c89c91cf5d993558f090debdd2e038a9f52bc8e12df5899a167"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "820706711e466dba83bab2b2e29f7fb5576ba9fad7eb79c31926e23b9cee6214"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c7ffd35bc4f875b89c21e99d83f9fc0e4e21fdcac59e3952295c8f62984711"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f57dc507ca12cdc5991fbc8eddeb13d7cb8de0442ed0c93b8f9c06d1d45c52f"
    sha256 cellar: :any_skip_relocation, catalina:       "437d859b520a73d0914b996f4c54c3faa48761ecd63bb9cb84c2e3eced866731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d38fc4e5e187eeecdb09c6e6c4e1cadb24f03d079bc261c3df4e395cf78715"
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
