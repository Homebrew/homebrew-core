class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.9.tar.gz"
  sha256 "fa55db244a60667f8cf7a86a8b9d53c7df6ab22f4498e7665ae6bb8d36a4c97d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f29e189e33b573432e53178bacc3474a179eeaed4169e7e507bc1bb879bc9bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f29e189e33b573432e53178bacc3474a179eeaed4169e7e507bc1bb879bc9bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f29e189e33b573432e53178bacc3474a179eeaed4169e7e507bc1bb879bc9bb"
    sha256 cellar: :any_skip_relocation, ventura:        "0afb54e4cf565c5360ed6974ea0a204a2ddfe632565d18f3eeb0225d6765e30e"
    sha256 cellar: :any_skip_relocation, monterey:       "0afb54e4cf565c5360ed6974ea0a204a2ddfe632565d18f3eeb0225d6765e30e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0afb54e4cf565c5360ed6974ea0a204a2ddfe632565d18f3eeb0225d6765e30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c2326122382455665ce23b9f640225d397d832518b28445a835cbd64f681a4"
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
