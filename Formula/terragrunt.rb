class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.9.tar.gz"
  sha256 "4655bd4d9d64ab36325680edbd0fc990f8db715f6835f5bb8ebaa4ee7df0e858"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85357f3ece8509980284ed4c3bb4cba5d463f8a7003ed92137e3143588ff6de1" => :high_sierra
    sha256 "1375777766aea3f263668e7c7749c4ee331c8ba73d11a0d65a3e7aaba9d5decd" => :sierra
    sha256 "f4cca4d7442dfb3596b53845cecae1aa3699cfc04ba7d85f9d1d1a07a180fcbd" => :el_capitan
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
