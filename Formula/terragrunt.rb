class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.3.tar.gz"
  sha256 "b38c7f72ece72bfbe719486f4196c225a02d5e0c1345ba8ec6dacadb8eb58c59"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e0cb69a60b9971d9e70d9a0f7bd2ad643d4d2d3ba32e76799622d52b109c977" => :mojave
    sha256 "8811766c2d2baa96a5c5b8aa11bbfb95fdddd8306c27b760ceed08d7abd683b4" => :high_sierra
    sha256 "a9295365fc0843b0c651c15f88ddce8ee983e7e49717def48f1a42ce7f7e6ce9" => :sierra
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
