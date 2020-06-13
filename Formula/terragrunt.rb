class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.26.tar.gz"
  sha256 "38af9f84abedefac767fd3898997f63df4178590e03c95644cf3f8390075b58a"

  bottle do
    cellar :any_skip_relocation
    sha256 "84884caced8acb890d3032d767d7e6d8e1c62f1edba2a75bafbb93895ee456f2" => :catalina
    sha256 "1bfbd410868ba035c9d4eb1ea2a9ad9cca45e67c8366a37e64cdc88c4bdeb4bc" => :mojave
    sha256 "58fe5043da90e2455d6da6834c138059a0765a1ba03127e0d340c144ddf2e681" => :high_sierra
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
