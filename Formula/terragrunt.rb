class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.8",
    :revision => "f0088b66cd1af04e04747e4fa64bd9803ba2b0b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "b844b8023db001c52de749b09961d3e36cf2ddf7254178dedfff87b3c1e4d0a2" => :catalina
    sha256 "412a0f2f0723126c06ac81682575a0ede4e1343dba5c39e4711567b2a890a1ca" => :mojave
    sha256 "7634bd2928f46b6305bd35d05f7be453ee248f0cd8d9ffb573962137eb6b3682" => :high_sierra
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
