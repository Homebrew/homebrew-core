class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.8.3.tar.gz"
  sha256 "7713e4b93528c294db86d008a2ab09ed841984ae2d1ea6f58c3703dab3a1b21e"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbc059a7c2f0531b4cd54d8d5e59f4399149a23be6599a2bff948680458fead4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc059a7c2f0531b4cd54d8d5e59f4399149a23be6599a2bff948680458fead4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbc059a7c2f0531b4cd54d8d5e59f4399149a23be6599a2bff948680458fead4"
    sha256 cellar: :any_skip_relocation, ventura:        "c06fde3016f16de98a2f9bed2388bfa920811416c16de1fc97603f08c86e3928"
    sha256 cellar: :any_skip_relocation, monterey:       "c06fde3016f16de98a2f9bed2388bfa920811416c16de1fc97603f08c86e3928"
    sha256 cellar: :any_skip_relocation, big_sur:        "c06fde3016f16de98a2f9bed2388bfa920811416c16de1fc97603f08c86e3928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "813eacde1d183693a25d5b113afce7065933440df1e2536264dea7c072a8b1a0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")
    assert_match "Error: one of --module, --hcl  or --tfstate are required",
      shell_output("#{bin}/terracognita aws 2>&1", 1)
    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end
