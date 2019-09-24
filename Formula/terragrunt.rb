class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.26",
    :revision => "ced4107a57dce0d75b7ccb81671d6d40cace0416"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcc058aa0fbe6dd507dacaf814144d388dd0d931c0ed7600cc4aef11bcc8599e" => :mojave
    sha256 "8d244a71cddb26dbc81729ef5d344a25f65770ecb5bddb5e86ad545281505c7a" => :high_sierra
    sha256 "bbc6405baae5ae4ecf101cd58f12d4f643f9523b0b356c84ce8cf12288b771fc" => :sierra
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
