class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.5.tar.gz"
  sha256 "52a0df3a206913e955b3ec5c3e58c23751e4b6fc2d178cf0e49aa04a4c83abdc"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80db81ba69553c40fcc52029e40545a139ca0f53cb0eb8071a0ff41f4ae09f72" => :mojave
    sha256 "5e1aaa94d4814b4d6ebfe3052318b703fe81981b2c03a7ccc907c50d6446e293" => :high_sierra
    sha256 "bb60a1844a56f220ea43fb7f16c9a10c18f24fa069eb60b967f578ba85001983" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
