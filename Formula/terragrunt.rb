class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.1.tar.gz"
  sha256 "697587bbaf33e3248a8cc8565bcfdb9c80a976721aa42145c8b04cde1433b41c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d541e6c3cd5d7437a439f1d7f26e0ec35503361d22ddd1b4911c145f0ee0651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb8a850174b54fd47c03630053c599e1cd6ae45be819b222ff74d2156ec842f0"
    sha256 cellar: :any_skip_relocation, monterey:       "24edba32ab7aad8a7e081935b1f44b8eb59c34a225fb9205c15d69d0b2869f19"
    sha256 cellar: :any_skip_relocation, big_sur:        "7636530dca72203f693ce1a76e873384449ff7370cfbfcca5610711a745cf4f8"
    sha256 cellar: :any_skip_relocation, catalina:       "b006ba53d9dfe76a2aa57323ec7b3d042459b43170eba9233c3bbe09c6521122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59cb420f981f945e314a8a30b68ef9c00bfc20c3d9c3e570d3cf857a82313b3"
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
