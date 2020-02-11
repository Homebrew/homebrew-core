class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.12",
    :revision => "06b7eb66392249faa0c5d4e8edf1775e0f6e5e46"

  bottle do
    cellar :any_skip_relocation
    sha256 "38b2b5d50cae45752c8af9935fa5ea3e3f36a7fb51cb7a280d85c1ca3ced0869" => :catalina
    sha256 "1d88541f00e6f6370ba0c6608071244efc31cf4b42cf25583fd6a5c181642ddc" => :mojave
    sha256 "dbbf08648d90916090d024140747dbec946bf2ce094060997913975ac6440d47" => :high_sierra
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
