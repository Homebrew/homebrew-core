class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.4.tar.gz"
  sha256 "c6b263d42ac7ec7fa4a0f15362dc2d93367a66597844bb9a1f1b52cfeb63c86e"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c97c1a567785b862e6124d7987c92f0fbff867571f69e42460a88fb80b1551e" => :mojave
    sha256 "03f16255e224c9a4129f0dd579c8f47828329dd307b8db30cca23760c5ec450d" => :high_sierra
    sha256 "3324a8c3993cf1aef29e8138b9f39fab694637ebee5333b36367c1575ced0b9c" => :sierra
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
