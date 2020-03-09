class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.1",
    :revision => "fdbcdba44c94afadbb393640f9eb57f7a9b697a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "eff5b6cb9a8fa37c639ff5a9c6b9c3efc3939bc3aa71cddf742c1d07b6f41819" => :catalina
    sha256 "a508013a79402fc4b6f3796dd8c28383936dcb406f482a29292fa4175ae222a6" => :mojave
    sha256 "909d1fb16a96205401d8c1a5e98f61a9fd112297a4c42eda727f43d436422502" => :high_sierra
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
