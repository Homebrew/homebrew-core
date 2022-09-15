class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.12.tar.gz"
  sha256 "4b467c7eecbf81d4606374e51b3fbe11c8d4f1303a252d527974caba8833c603"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e4afb485cf5e0057bcc43c30e5bf87c2a20ef369c1a941d35b6ccc845fce507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dda60d7b817ad33ce3b9a3ec218751a7ad18828d095026e5a14c60039d056bef"
    sha256 cellar: :any_skip_relocation, monterey:       "f11130b8f6287524f82fd543c75bac43f33550ffa83dc64aa530b7104e1aa5a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e432efc18ff763ffa47667c2b604ee248cd8bf1648e942b6e704862f0a1dc5f"
    sha256 cellar: :any_skip_relocation, catalina:       "ce3f75b8d0a37708961e7f10fec15495dc6812a313351becb68b633d03cc57bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da3d28eedd15992c0afdb29c2841371ca581b4c4c485e674b4a11c8c0dd2360d"
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
