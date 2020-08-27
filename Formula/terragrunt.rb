class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.36.tar.gz"
  sha256 "09c0fb393502efec9a2b20788f3b1a22cda96cc169b0c88ce90286717add1113"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6418d53a1512e6999c1e7cd4749d33f2b42a423dd41b2e89c5892b419b835f98" => :catalina
    sha256 "29f7a355fdefadffdb2c00addd5a7306bc14012195c16cdbca3c601b5fda806d" => :mojave
    sha256 "8f1b83c91d84861606cdc8c783da6670dd7a5915ef823572408599aadc687593" => :high_sierra
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
