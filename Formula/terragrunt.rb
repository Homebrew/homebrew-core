class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.16",
    :revision => "37832d50c576d4b4e120e17baf13bdec516110b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "46dc7209b5d5565a83342b96b014a53e56406818d9632485925772346321ffe9" => :catalina
    sha256 "efeb0ca2903e44fdeb124db62551eb5ac0fc87106f9e8c7d2c3b5c6f400efecb" => :mojave
    sha256 "358f8b947b99f487ddca1e1acf31ac61b4f038ed0b893c2306104f5d0761fba9" => :high_sierra
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
