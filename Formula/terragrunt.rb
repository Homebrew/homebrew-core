class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.19",
    :revision => "a078396d44bac85abb37819fb83687ae67ba10d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a52cdb541a4c950de23bfb3461e5cc37dad9055d63a408579287971d73466172" => :mojave
    sha256 "8d54944b7734feab102bb0af46a4e82f720a367002f76958c7bc66652a3d6556" => :high_sierra
    sha256 "4f86043344a0b3827eb9c6d6a4c59faa61446a5a5478bec8f236887ef408b309" => :sierra
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
