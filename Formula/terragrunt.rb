class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.12.tar.gz"
  sha256 "1ae143bf76c37237ae36aa07231c845639b907403f25e67ede6dc54b9a2fe2a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f69437c30e3a8088d02fcfbfd8f50c548cf3231d5d04c29bb18b0711448d8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a650383773df18fb0bad47b2dc2350d108c277e1259fa6adc20cbbe467ae1f9"
    sha256 cellar: :any_skip_relocation, monterey:       "585a82b014630c05b4978c5f1c5ab57bb037c57d905f01b19efef0953b4f95fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "515297a31612818b7c11048f64044a1c86dfa582aed7385120bd4681fa3f994b"
    sha256 cellar: :any_skip_relocation, catalina:       "eb8caa4b5345791368a6210dd0c551c728eaa87933b4db214c88c409df40b635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19c8229a6a439cc20cf35849a6da3df8d65a649e41ecaaf92e59e96ecfa709b"
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
