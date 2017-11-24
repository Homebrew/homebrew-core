class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.21.tar.gz"
  sha256 "0b265cd3c7640d527fd453f92c19caf27125ed5e8b517aadb667bba026022ae8"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d17859d2abd46f63309a9f417f22aae5acd33e5301b0f767bd4393cc3de58720" => :high_sierra
    sha256 "ae5a900e2e5ff844a34d60a6ce61f2a2499fba259a0a4387212661cad74923cc" => :sierra
    sha256 "0cda0c19fecf79f195f931bc9da8f57889b270e7480f74392c0c8e1796e6c677" => :el_capitan
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
