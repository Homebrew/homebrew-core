class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.5.tar.gz"
  sha256 "838e1c4280c99e49f29198d907ab835bb6e9b48b7a73a292513f3fdc90e174ef"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da3fc6d5108f881b33b2b273ec176a3461074f2c801adab63e4fea1ca38f3d60" => :mojave
    sha256 "53af517b469876c9799dc984957f12848ea2476fc961b545eb181fe15cf298ab" => :high_sierra
    sha256 "33ffccece744fc038e12923ada520a671a06f2b8920317e56a3a85b4ba139ba7" => :sierra
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
