class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.7.tar.gz"
  sha256 "9f2152746924c5591618ffdb02387b706328267438cb504e91e4e86fbecb2863"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e8c46a5036c2bff241875d34a32ffe532fdd7f8ae1446c28d6119199195b5e2" => :high_sierra
    sha256 "4f7c27ef74c09b888d10db9574f0b09e51ef4f9a1750180b563d6edb771ba589" => :sierra
    sha256 "043c6513885afda6860fb26fa366b1ccc799d1631f664f8fe00cf654a8408bb4" => :el_capitan
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
