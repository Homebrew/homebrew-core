class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.38.tar.gz"
  sha256 "1acea695e6332420dbee03e1824ec1560c852bd29d7364dbb5cbcae3033b973e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc3833635556c85ec65c3cdf35048d76c51a8fc5c9570a6ef6d334a86d002a58" => :catalina
    sha256 "0493aa91d68c93925dc8b4ce860015eab7a768c32719f7cf50ca8460d57e06f1" => :mojave
    sha256 "e998eb7560719520970712c3882517bcea83126faa2e4c8af471994dd62ddd89" => :high_sierra
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
