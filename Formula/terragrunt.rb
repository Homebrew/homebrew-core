class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.22",
    :revision => "c7694a55348e51ae65eff7a84ef3b52d5009764f"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf7c0bca0c3b7cc330d986aa6d521fd070a18e6a80b5dc3044c93d78dbfe662a" => :catalina
    sha256 "21c9b916a3c9298b3de66286e5967ef570cf572f2bc7469039013851d2f24333" => :mojave
    sha256 "18b012cd5ee4a38aa4e73a369c0a46bd211d87551561555a075143564c926d7e" => :high_sierra
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
