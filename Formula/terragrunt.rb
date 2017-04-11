class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.11.1.tar.gz"
  sha256 "997276ea4c42d541b570f72a3e69bf2e889382b54f9c1cf38b337ec9ec0553f5"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b3668250ddc3c5b42d2b8ac428a3f5e027e2f2cc9fdfdf0014c08dbb2a8532f" => :sierra
    sha256 "1ab73d428a47e8a134915c5f1ec3ca0e57bfb7ac2150542de20858cc4f47ec7a" => :el_capitan
    sha256 "50813aa660b56b436bf4d9e5542692306393ad2191408ef462b26652848b1bca" => :yosemite
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
