class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.29",
    :revision => "c5d252a82e47e5508455452ec93ac8dd516ed46d"

  bottle do
    cellar :any_skip_relocation
    sha256 "44110a2779ce5d6f0756d2faaf63295828ddd63fdf9b994744c769c92b23635d" => :catalina
    sha256 "bbd66dea83bbedd424a4d47d7ae508de5ecd955dfd2daf841649beb73bc45c8a" => :mojave
    sha256 "19849669a2535598183cb471e8a67ecf13adf2d5c0b96611eabd78ddebe342dc" => :high_sierra
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
