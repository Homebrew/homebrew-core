class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.33.tar.gz"
  sha256 "28e5a3bc2d9ec9ad8a2037680ba28214267ec974f6d8315ad23730c222c6a1fe"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b62b89970789e99a3b8f10347e2c9b4efc4b4fc564a10a70ecaeb32edd5ce998" => :catalina
    sha256 "8144a12b6fcc8039a8f813fe28aa7d39c05e5ee3bc608f5b8d1afa1da8d63879" => :mojave
    sha256 "c4cab9c0a5b35ba8207d711b31dff02467807ef896361fc4c5bce0a4c5912964" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
