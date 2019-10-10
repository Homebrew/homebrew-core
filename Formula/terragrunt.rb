class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.20.2",
    :revision => "a602f2535b12c2ff559839d2901dd8bb197ca2c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "16c6b408e740b40c780e555e92e256355633919d56edfdf65087cb13c3c19283" => :catalina
    sha256 "2e8eb9dc9edb6cc1bad3daef7bc596962ec6ff0d69cb65a1913a81ba63d2ea94" => :mojave
    sha256 "a9ce4a06773c3dc8e7ee6b260aa4b5547bb4af217e14eb8133ddab27575a7de1" => :high_sierra
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
