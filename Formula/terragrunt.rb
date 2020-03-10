class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.2",
    :revision => "f774248751ec2e46d09823ab3c6192a35c567b27"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ba4684e0118fa395614aa162dead0a5edc58a6c0a476f832a39715ebde242db" => :catalina
    sha256 "06ef1f8cc45fa82412a315092e634447dc69dffa7db0bc24a6a76aea458564eb" => :mojave
    sha256 "3d55e2ed294d1c0e88f570b7769bcf3f008208b1aecd7cb2d341de50cf6c89c7" => :high_sierra
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
