class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.6.1.tar.gz"
  sha256 "ed8ad95140d5b99fdb31c0db65e1ee6ba6345f91b4bda34757d80924b68850d2"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45f117c3bf18a9ab039f1efe68d741dc242165e392f5ebaa177dad525fbeb77b" => :sierra
    sha256 "96dc1c27bc567ffde08c2c3a1aee73c699555148e3f40b6d6fe711a346f44b2a" => :el_capitan
    sha256 "d27f87eea29c80d9e799fe7e21d9c3b7223d42d4dfe7a323e6b22b20344b5b11" => :yosemite
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
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=" + version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
