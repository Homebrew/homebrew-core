class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.21.tar.gz"
  sha256 "9515bc4f364b60a819b2933778f0f168c5fba0aec7a8959bde03a9e74b84bf3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47fda3005f9822bea919e4c1a1966617c40b4c6e94fc786a2eac96220d48c66c"
    sha256 cellar: :any_skip_relocation, big_sur:       "73d47fac220deef7cd6361e7e9194ea4125bc5dfe3c4a7879a720f8aace46fa0"
    sha256 cellar: :any_skip_relocation, catalina:      "5901d5b6d1e761d6c6dc40bef596065901d1649571be85dc3eddbd3f2f0d3ddb"
    sha256 cellar: :any_skip_relocation, mojave:        "04eacede91fe52fa1da34429aa8cd33fa4e7d9d4954d83c88e4465be6cde3ac3"
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
