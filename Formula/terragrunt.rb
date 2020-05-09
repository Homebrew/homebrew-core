class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.15",
    :revision => "1fcf15522f2ab512261c8344202bbaffb82d2395"

  bottle do
    cellar :any_skip_relocation
    sha256 "04b85bf0646a8a3fdf2318e39606ad91741576aef95c224e8bf8b16831226fe1" => :catalina
    sha256 "4d4c20e50c32c0871a35dff33ceed1565aa6d02df46168ad8b8e4c5d3c61cfb0" => :mojave
    sha256 "26e7ab35a96b1ce77dfa0b5088bda62c4cf85026e9ae462c26cc5b2f354672d6" => :high_sierra
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
