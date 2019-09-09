class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.24",
    :revision => "98b476318cef0e81c956a4fb406ae41d70e30e55"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bbec979336a0e8520f67e01be25a595d79557f095583fd59ccfa7a3557b53f7" => :mojave
    sha256 "fbefd024418ae53fb333dc9ba9d80f0a2d5b99a5b9544b28f1072bfaf69fa3a1" => :high_sierra
    sha256 "ab9c7dab716ad7cee1caf486788df4e7ddd8662dfb0cc2ebe459ddbfb6026856" => :sierra
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
