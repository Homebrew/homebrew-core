class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.29.tar.gz"
  sha256 "f740dbaf74295aadbea90cf12d441ff18b0831f791ee03418655adc43c320e9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a08567dca5ea81b7cc95c5ded5a3561cc947cd2cf286648763f6a3f20a0d79fd" => :catalina
    sha256 "e893c1a1ff6ac1edc2d48d6276ca63ec3f6f801c635bce82291e7dca95af174a" => :mojave
    sha256 "35331120f568dcde841f8ed615b408d17338f04fab41633647c98af579f4b102" => :high_sierra
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
