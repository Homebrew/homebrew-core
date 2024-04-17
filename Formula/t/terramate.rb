class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "4d6bf79fa56b20aee30522ea61f7181c8a8f7b91b94e74e7911106330ad59efc"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e69d914a5380c49f70f68863bdbe94ade2f3527b1c8f6c3c14984911c2af238"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb19752db77c61e6e7047a79b4acace64dafd39f57001ae061f349dda3e82454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50fceb5c77c8b492b5c7bb94928dded23a04d225c7223b774fb76c1734d697df"
    sha256 cellar: :any_skip_relocation, sonoma:         "6be7cf8115754d3d9cac0cea3c58fcb495a1092801f0365b3ab51bb7ce7b7131"
    sha256 cellar: :any_skip_relocation, ventura:        "530f0d7e49e96ce1e2b8016ed8f736deaacc2bc668c0e6a8f82217a7d09c4962"
    sha256 cellar: :any_skip_relocation, monterey:       "e2bfe07834803694e96883d1d34eb4e6540238305aed35cbd3bf5185d8edc9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939805eacd51d7e1ce894efe854bd515daa7226d2d8574af571f5ad4f12e574a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
