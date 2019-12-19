class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.10",
    :revision => "7f563c6fe3abe41764aff642f01edc180288a9af"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f7a041923ed4a5cfafa3ba6511eac2ca8a17a7d8bc537da2187d55852f93fa8" => :catalina
    sha256 "18207bd6874a48fe00ae3bcb992248c2dd2df2d1d3eae0d76a93d21c65edd435" => :mojave
    sha256 "d44875e4dc0754ecae2a239b7eaa4c3d4e6ecfe8bb78c175c2920c6da7efde91" => :high_sierra
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
