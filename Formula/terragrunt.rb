class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.4.tar.gz"
  sha256 "8ad4fa6e9e9c075a8a04f76117a6ab05a062cd6fe0fd0ed1c23937c7ec272839"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6b3f69057f068b8599ffc84799417efba9f24e89230db5541d5b08d212dd9cfc"
    sha256 cellar: :any_skip_relocation, catalina: "6c95d4a7665ef9a33dc636ea2e1d7f968f0ee501ee321a937036ed6e99d0d683"
    sha256 cellar: :any_skip_relocation, mojave:   "c83e5504db26683e28a1bee121135c93727ba29e8ec46c143aef9d8b140f1ecd"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
