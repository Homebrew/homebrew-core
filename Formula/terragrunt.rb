class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.22.0",
    :revision => "fb099f48557d2de6413e1a3edea3ef6a3d571af2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8f7a02e03edb18bcb1f910062113054a922b100f6dcc257ba5e42f08fb26b5c" => :catalina
    sha256 "9fe04435b08029b5b3a898f6572d7f1f14184319aca4b319957daa0fccf27f95" => :mojave
    sha256 "b50f49645927a3e0fa1c4280bbda0bef5e0dee3ada1741794fae1c9a745ea86c" => :high_sierra
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
