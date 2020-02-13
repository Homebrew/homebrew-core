class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.13",
    :revision => "d17db6693618cb77b2fd24c305fc323a8c5c61ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "68bfc1a5e865b84bdae43b4ceb71a61559c761b022327fdef629f78330cebbf5" => :catalina
    sha256 "4497de0fef57851812e15a5890d399d3c1bf8ae929efc9278ca85bc4845e67ab" => :mojave
    sha256 "8b58c244b45d26ffe8a367391b38cf23992fbe25f8add3325c737fdfa08dbd2d" => :high_sierra
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
