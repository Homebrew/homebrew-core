class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.8.tar.gz"
  sha256 "226f6e0d8a60e026cb0d4fc0f41b4314ee14cbab78e23f05376259b254eddb2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d43948ff591135c455a25bfd9c876697351d4f73c6c796237d9010a1d3e86ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c06695ea6175f4457e541b895b60a80e381eb5d0e1070ec0c6a1ba61341b03e"
    sha256 cellar: :any_skip_relocation, monterey:       "e279921168fa34678bb2fe76e40d90c6a465f33d33ae2e888d3395daaad08c8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "604c35f1e029d77883afd9c322cc635093d8ce86eb4933562cbc62a8495bccc6"
    sha256 cellar: :any_skip_relocation, catalina:       "bee2b903c98faf68003ac8f22393ec17395980c1d070b3f6739f955de286cf14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e82db096e5232ade1e8b1660cfa82f5de0fb58cd3b65fb1a9bd9034ef3385c"
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
