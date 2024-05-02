class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "1a5d1716627ff42daf1aa74050107b02667a9f0e41988821b8b1ebb890dca8f4"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "875b36142e1f8f1add8ca851636b7eb717aba40a081bd7fa035e5bfc9a353342"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bae38b4b4347cd80512f5fffa3c3d60ec560cfe3658de32b99156901ac33d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e4999c93ed248d43c6c5246e65b6964788be9a707337ccacc5f2c522f2a62f"
    sha256 cellar: :any_skip_relocation, sonoma:         "becab5770fef53988e1bc14cca91abee0847912c366a396d2e117b26e4951791"
    sha256 cellar: :any_skip_relocation, ventura:        "2d50224e1d6f9406522f8789d9057d9628e6bb06b2d1c105c3bc99c10f376334"
    sha256 cellar: :any_skip_relocation, monterey:       "d570719b4f0213e5cc8ff0c176d073e0e670193e01e9d0abd3e11ead668ef414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35ac484b58e73af9a906de7cec3e9999dacc50778e5f5eb51f98a9c1aad04892"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
