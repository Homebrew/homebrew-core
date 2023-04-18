class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.3.tar.gz"
  sha256 "872202cd9a50f974d620fb18e89349dde9b0fdc74c6443e56af8df347f0c1a35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa7c7808c615a62ed57b2bddd30419010127a355b09980199643a32c974d9f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa7c7808c615a62ed57b2bddd30419010127a355b09980199643a32c974d9f54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa7c7808c615a62ed57b2bddd30419010127a355b09980199643a32c974d9f54"
    sha256 cellar: :any_skip_relocation, ventura:        "606983f689518174ae13bec15a0218053c1a9781649bd5fdcd71a4354036e950"
    sha256 cellar: :any_skip_relocation, monterey:       "606983f689518174ae13bec15a0218053c1a9781649bd5fdcd71a4354036e950"
    sha256 cellar: :any_skip_relocation, big_sur:        "606983f689518174ae13bec15a0218053c1a9781649bd5fdcd71a4354036e950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16690e4f6b6d17238880a0a7b1f3455857ec03fa182347829f6b3f0efe5890d3"
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
