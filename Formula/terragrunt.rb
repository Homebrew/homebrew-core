class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.5.tar.gz"
  sha256 "52a0df3a206913e955b3ec5c3e58c23751e4b6fc2d178cf0e49aa04a4c83abdc"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9d35aba2e6e716283704ac7a58c4e49bcac7d2535a314cb5edd4bcdb04eca38" => :mojave
    sha256 "af45c409b6a13b50ac90fd152c2339cc320d37a3efb0b6f8d725a359823a7686" => :high_sierra
    sha256 "578f0f421941d1e6ba1546e0c54754f0309d84205c73ca3d5a20401c4e2d60b2" => :sierra
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
