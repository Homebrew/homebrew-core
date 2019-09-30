class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.27",
    :revision => "61b390169803dd338a3b28aca2a25617ec2e4051"

  bottle do
    cellar :any_skip_relocation
    sha256 "92f95cb02606048ea5963b40258cd54bfd5f21627a17ed8cafa2611f079d3b4c" => :catalina
    sha256 "9bf0b216cf161398570c7df92551d1b3cf0fe900354c6877be9a7f7d76d872a2" => :mojave
    sha256 "1809bec54de76aacd8649eb47af8e586e5f0aa8dc5b1a1732d8490910a46e810" => :high_sierra
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
