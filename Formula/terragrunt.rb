class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.14.tar.gz"
  sha256 "e35bb9cc4f74dbc1f722cc21f2f19b15c76cb19bf408a6ab0d92d413b21098fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39420216d46915a4b04c9d56a5d821f92c54c09a81610fca52c2fb051250b907"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8ff9b4d637b6cdedf108e45605cbfc10a10fe4a15ab8a05b2dd660c06662f89"
    sha256 cellar: :any_skip_relocation, monterey:       "2961d3455532fcb979cccebbc47d7527852cd601c91a7ed503b21c0f8d821bba"
    sha256 cellar: :any_skip_relocation, big_sur:        "55921b296d71a219d26487d300bfc79c3ed44218179615bc2e306765408f26f4"
    sha256 cellar: :any_skip_relocation, catalina:       "2043ece09b2789037aad5f9b3572e14fea2adc03353f96976bdee06599d1ebbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc19e8452ad7c92d2efa7bf5f48b49de4c263895710902c526a2919ef64683c"
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
