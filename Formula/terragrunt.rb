class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.11.tar.gz"
  sha256 "30935960d6f43283a3bdf6c0b63efe33dc26ce0fe38f6459384c5d8b5447eb9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5c9718fb07611adfc54ac0ee0e55ca9350d1cd883f17b91886437ffceab585c"
    sha256 cellar: :any_skip_relocation, big_sur:       "543a88ac50a571390617ec40aa61b203ca3a55a6a32fa4f0ee4d71af3186838c"
    sha256 cellar: :any_skip_relocation, catalina:      "87ac33c9f8e20d11c9adbd5fc0caec6f563321d13ec2731eae36335b374ffa71"
    sha256 cellar: :any_skip_relocation, mojave:        "be4f2ed08e6a05121c578ef588ba932d7290f420e7ff3c498925e41fa71acb2c"
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
