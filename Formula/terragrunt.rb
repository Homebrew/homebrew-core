class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.16.tar.gz"
  sha256 "ab4adcf7707b71d56190bb65f8d0e340eefd290d86bdd3a2ce1e679ebb418039"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42ba8ae492d399ddf94269b3f33de0bbc204e18d7af31e1167991556345b8521" => :mojave
    sha256 "9edddd236b46be93c65a449b7448867fa5e49134e959c175cb87b3c7105949ea" => :high_sierra
    sha256 "5963b0b8fb731c1f457603cd7a04a9f4fb4adf4a422363b84e75fd7939142081" => :sierra
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
