class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.0.tar.gz"
  sha256 "c33a64d2ea7da1a0c728c1b5f4b7f9d3517b764cdd8173e4a0504720ea4dc822"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5c9fc08ea159df79d8048bee0fe9d3e032d4e23fcb4232cb2842d2f5979bea2" => :mojave
    sha256 "ae0954bd9978ddb38c74c356cb9fd1b9895486157968f2bf91b39617716ee024" => :high_sierra
    sha256 "2ce981e3e2880048f6c16529a7282eebefb7f796f99ca8079461244157b9a2c6" => :sierra
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
