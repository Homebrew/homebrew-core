class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.66.8.tar.gz"
  sha256 "c67e31f2be2bf5ce0a33744ebf963a07ff9b511d53fbcad488ff9107f364fbbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cde7ee985235acddadb0736210963e0d9aad6814122956fc5a92a5fab988153"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8b13d32cf2532af6462276095469888bfb1041393bb7b09228619694e51e592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb9f195a1545af3f3a0493c27a11bd47a34bb7665e2e40f4fe02ddc4839d5054"
    sha256 cellar: :any_skip_relocation, sonoma:         "523553d4a409a5c81a1152744c3e89c902f369d15d59012625f489bf57284e05"
    sha256 cellar: :any_skip_relocation, ventura:        "53fca4c38d21cff42f99d3c4e87810867da44087955849404439b1d46dc85d06"
    sha256 cellar: :any_skip_relocation, monterey:       "c031c3652803a0857a626b3fe54ee430c807513e3001247c666cc3b1dfcbab82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bae6a640bf6acb82a42db296e4364d388c2c8df13d5c2c66454f5d76e16e222"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
