class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.4",
    :revision => "d9e6bd09cae642fa600a99026517431d06dc8192"

  bottle do
    cellar :any_skip_relocation
    sha256 "bac965eec78425478b0a3c6808ff8505a2b2c173b4c38625fd47289fa10c5639" => :catalina
    sha256 "07973f705a780c2465ede33797540e97d3ba532cd2ea06baac9d81c94a9d7fc2" => :mojave
    sha256 "2a04dd1b37f9ac1a0dcb59bbb7206e610d94ef8a4a015b560bf42abc3bdc067f" => :high_sierra
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
