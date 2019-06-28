class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.6.tar.gz"
  sha256 "7731c5b16e131e823a95ac75010ea796ba36f93484ec295ba9dfd8687354c569"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0213d2e5e1064ae730dd28e250d69a6db457fedbb5418360b72b3b967bf541c" => :mojave
    sha256 "b4e4e30f71d2bb0671b32a2effc77566ddab430d67a2ff3980bab76a0144ec79" => :high_sierra
    sha256 "00c09cfba30dba9cbfb3f02a5f66c9be5ff423e2c248aa317cb5aeed90d4d8ed" => :sierra
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
