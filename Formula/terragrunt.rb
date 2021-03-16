class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.13.tar.gz"
  sha256 "3f897eb120d86d86e499de59f61e37f59b3dbc119568efdfd4fd21172d422271"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "296137a8e3dc72a588831e160153b5e85486391ef948e8b4bf335f4775dbf15b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d6d52cbd555bd93b4eeb4238addeb7c27c680454e0c5438146521069882b416"
    sha256 cellar: :any_skip_relocation, catalina:      "facb301e542d4e7766b9c1de3758b21e61685830708714dfd3e5cd2df3a81ed2"
    sha256 cellar: :any_skip_relocation, mojave:        "51fc47c608515969af8672d2694de509de6be1b74d7e42612ae60b87f33133bc"
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
