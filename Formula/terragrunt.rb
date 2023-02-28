class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.44.1.tar.gz"
  sha256 "192a759b5481d4d5a6e1a477a8298c48c634e185228df954b618c8012301e998"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d29afd9b1320eebaf465d7dbdd9af3a8a509b923c1e1809f95d0c5ad7d8ab15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d29afd9b1320eebaf465d7dbdd9af3a8a509b923c1e1809f95d0c5ad7d8ab15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d29afd9b1320eebaf465d7dbdd9af3a8a509b923c1e1809f95d0c5ad7d8ab15"
    sha256 cellar: :any_skip_relocation, ventura:        "6eb2807bb7bbd0a8454c5c8d7e8b3e3724121af5d1f8a805ff44839cfa78347b"
    sha256 cellar: :any_skip_relocation, monterey:       "6eb2807bb7bbd0a8454c5c8d7e8b3e3724121af5d1f8a805ff44839cfa78347b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eb2807bb7bbd0a8454c5c8d7e8b3e3724121af5d1f8a805ff44839cfa78347b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda0a905f29205a779aa04ef80cb2ac2bb628d51f50675426673f6bf1cc49927"
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
