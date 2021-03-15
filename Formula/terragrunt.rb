class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.12.tar.gz"
  sha256 "b9bedfd3ba49d51ee9dff323b448ad454556c32437533d264899fb65b2195aba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c27e721f6887db295a4e0a769af3df5013459c9cb38b26e5e1256e59e616524f"
    sha256 cellar: :any_skip_relocation, big_sur:       "039bc35a212cb903892257fbf70e708b68784c51589c89b62d0ebc5ee02a11bc"
    sha256 cellar: :any_skip_relocation, catalina:      "2b510047a6a63dfd60ce3f3b548e935d62cf43d88c6f667232961bd989c522d1"
    sha256 cellar: :any_skip_relocation, mojave:        "4ccb9dcfa82f975abea4edcc3b74790a9a898701a1a7deb00f99618c354cf2dc"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
