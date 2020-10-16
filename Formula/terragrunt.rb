class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.25.4.tar.gz"
  sha256 "9701be0182015c0505a77a99a9ea06ad1d7bffb5fa16f65cc0299d8e666991f7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "60f7309b90fda8fe1e7cda4462e364dacd5f6282f04a18837756d9cd172018a7" => :catalina
    sha256 "24691150ded3c88ddacf48e2e9dcf353b0afa16348655ea10266564ebcccd08d" => :mojave
    sha256 "76ab385313f38f6bfbd7b685a9df89c7b90052fef378f767c02398901f8e5b65" => :high_sierra
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
