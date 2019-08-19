class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.21",
    :revision => "165ddfc6ff4632cd506da95df238ce19904f4ad1"

  bottle do
    cellar :any_skip_relocation
    sha256 "807588cecae7268dc8a405e7fc350b6d99b84c0c866767e4075a5c8bfcadd0fb" => :mojave
    sha256 "1f1aa970293c1a2044a4d48f6e46c3f090e52a32bc5509dae8ab9aa7dded4221" => :high_sierra
    sha256 "d145037960e41ed1650f7c4b8e39b0673c950b4513818d10369c466db67b71fe" => :sierra
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
