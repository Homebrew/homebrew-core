class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.33.1.tar.gz"
  sha256 "c10944f0633cc8c63380661c71da989a6d38c09ea3c183fd216742ca51f4e964"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "517fbcb2f41c4341c166ddd8056fdef50642c78a79dcc5fa6e9aedfb3d7f4dfc"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3b1e88172d9c44a41afb6545ad7e2c7b3c630addeca6dd0ab72c209eaf67fed"
    sha256 cellar: :any_skip_relocation, catalina:      "bf8c574651eaf80e5713abaf7397703b6536ef4c0a4c384b2d642effeb555c7f"
    sha256 cellar: :any_skip_relocation, mojave:        "f03657656d13694fbb661c42a6902fa609cb6bbe8923a295c56bdea483065687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf3b74aaed242e7d48e0f294561eff5c9c15ce579a0a3753186ae9a11543604"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
