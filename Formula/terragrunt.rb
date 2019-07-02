class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.8.tar.gz"
  sha256 "cf0b9b500c7162ffd915f2bc302d4757c10d618cf3e72ee7cc6611a20cdaa040"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4166517a107d5e4e73f1ebb911718c040e747b2d5497e4707cca92f013cc69e" => :mojave
    sha256 "9eb23540f5ba4924fa130ad5b3eb39e2fb220190d19626fc20e6ba4e4d2cd275" => :high_sierra
    sha256 "51ea8da27ca548462441b8e015beed7a4189b5d3252ab123667f0deff862ee24" => :sierra
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
