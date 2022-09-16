class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.12.tar.gz"
  sha256 "4b467c7eecbf81d4606374e51b3fbe11c8d4f1303a252d527974caba8833c603"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0730206a517b8fea6532bee33f4bc7f3a4bf5c372d933fb345e70c4a70be5a44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "075de8ec88cfa4982999085a508f64c86817af81c93f6bb92c89a31716989d7b"
    sha256 cellar: :any_skip_relocation, monterey:       "891ece8af5b778d903544af711834c4e632842b4fc67564ed18d80565bcfb5ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "b55af38ff5addc6de1eae0038a79ee8767cd64f0558494ce900a296585415fe9"
    sha256 cellar: :any_skip_relocation, catalina:       "1f72ce6f6c66aba525e48b933edf239ecd0f75f2319841132818b434629f8789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b05a9f9f82f52cf8717c90d1944fcd2e7c9fafe719188e33e86a1f012687e0"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
