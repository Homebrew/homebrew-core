class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.13.tar.gz"
  sha256 "a4be0dac187aa4347c6c802bceb01956de50a7b59d368cade1d984e3b4019797"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c420e6ce95bde17d4b2e02e63427feb4a8b2ddf081eb73c6417e29d93224797" => :mojave
    sha256 "c6a4cedbc300ec6449cf1bd0ceb780a163949e4af3900c50795e5e36cd52ad79" => :high_sierra
    sha256 "20407e92a454691e7458b1562b7e2f7ae81ed508d424d86caf8e8fcd1bccfec8" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    system "glide", "install"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
