class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.1.tar.gz"
  sha256 "189c03ec01da91e075706703bf4668f13a4b2c833cb47a9ced26844fffb85ecf"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53e79e724b64db4f798d215aa74a0c57a7eb4efe1cf012b11de82c6c89dee8b1" => :high_sierra
    sha256 "903c513f01e592b5383c4703fb3aee7be4675c041f9da799786142fe6cf46bf0" => :sierra
    sha256 "c32327724f5d55f33caa0ea5f10bf3a7e219980e7c9367ea144cd80d50f4069e" => :el_capitan
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
