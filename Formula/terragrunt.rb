class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.17.tar.gz"
  sha256 "8a5d914f5fd9124ea4403afad8c0fc2d26c37a6b68275b6e9c827f4ea23203ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d882732501c22e391d6dc04e49339a958caa86606748d519015d2cac82af8f5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "340421bde0ab6d6de3f4ebf395b06803fc5790bb59a66f92ccbcae59728ca7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "93cdb00613315312724c7216969799535cfe76440888199bddcf0f5f028fbc75"
    sha256 cellar: :any_skip_relocation, big_sur:        "70d7073e5370a7cc54e078a2721e723be778a4581ffd388cc83d8a3a06cc2d66"
    sha256 cellar: :any_skip_relocation, catalina:       "6d632e8e8928977125ea58e452fa17d588feb8f0281050e049914bb42b348a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2930227786bc64334c844ab75a03fbef76f0ad8da7c2c6806510c94007971d7"
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
