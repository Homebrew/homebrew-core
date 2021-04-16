class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.24.tar.gz"
  sha256 "4d50d457ceedcf4c03b2cabf118f911b81ac7923fe9a1a8cacc02a1bfe107613"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ddd9a0d1a1b49b4f2f2a18b75c34580c21d361c65f996e48055507d9a5877266"
    sha256 cellar: :any_skip_relocation, big_sur:       "a47ac1dedb6ece90370a1e52d7aa0630fb77f4cd9275f597b3b52d3b8aedc290"
    sha256 cellar: :any_skip_relocation, catalina:      "6726e235ee4f7be1c5e1af522f75400a8d9d7894488834267d5e11c2a92c0c12"
    sha256 cellar: :any_skip_relocation, mojave:        "317d4cc25497a67fc6d4c0eff741e0587bd01be2cd8b2a959bd34cd2ff939f98"
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
