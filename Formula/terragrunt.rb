class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.18.tar.gz"
  sha256 "a220559de76ac802745fc902015d69d3f49dbf916abcddb73c2942afe6115b84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88a56f5f5fc101190a924ae63c513b8ce505ab8a19418cac171857aa853bb61e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ff4768b47519a7d94c38ab5330e1e68e57cd005e492893be592742525ca2a502"
    sha256 cellar: :any_skip_relocation, catalina:      "bf81b3eb10878ba23086bbccf4f49f30c4323c4206410d3f7c778629b4cd3be1"
    sha256 cellar: :any_skip_relocation, mojave:        "5f8508cae4b4d46bf1c6f62441e8147efcdd82b9879b55ede31dec95e0e4a3cd"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
