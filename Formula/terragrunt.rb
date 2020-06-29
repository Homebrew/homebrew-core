class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.30.tar.gz"
  sha256 "e86802fd4c85d942b205f508c607071afd34a0e03d4e0d883c0228252805a24d"

  bottle do
    cellar :any_skip_relocation
    sha256 "57b1fcab7d023ee01138206f1fe33537bf720312c0e23eaaf4b6aa9c6741f7d1" => :catalina
    sha256 "b82a1d624900ca866fdbc358a560fa9202aa65a57e401e6fca3cf127fde21f6d" => :mojave
    sha256 "798829e597ce63b37690c13ae7202f1a645fe895efee22de61713bc285fd0446" => :high_sierra
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
