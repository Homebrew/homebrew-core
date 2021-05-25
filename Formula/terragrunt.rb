class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.6.tar.gz"
  sha256 "72c7b3ccfcd111f77abe22f1806a4f9939733dad8ec46dd067d7e45dd0d4876a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e5493ccac5cb1fd3fe53b887007d888c82d885ff686b67fc30fafb5a9f44e63"
    sha256 cellar: :any_skip_relocation, big_sur:       "29f4fca4e0bc882cf66635ce139b8d9d90242cd9e8788d2eeedb6af56f487cd1"
    sha256 cellar: :any_skip_relocation, catalina:      "0ab5397ff8e3d14b1d09349b7a36feadf1a731da82d7abaac17e16f5047bd727"
    sha256 cellar: :any_skip_relocation, mojave:        "cce4fdac0336fd3a607d2163bf295d5cbcb570d1061ca0979f67484ad5cbff9e"
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
