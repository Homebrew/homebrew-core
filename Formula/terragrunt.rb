class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.15.2.tar.gz"
  sha256 "fc84844e9e77e2882e3934d5dd535434cc38789d9767100be21454c997e38ed8"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5464234d46bead3a4bd6a5464e048f52ba2dfae1c43d437440bfb07863c5e8c1" => :high_sierra
    sha256 "2a29e3ba478642a9cd46ceb44e397a3751bb3cf72ce7821e01d95a10eea79652" => :sierra
    sha256 "3602a0b7d9dec90257b737c07005c0ebe309a6db795bc3363bf001f7bc4be7a0" => :el_capitan
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
