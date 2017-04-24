class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.7.tar.gz"
  sha256 "d4cf68a1b8aba05c5036d3ce894d52d7245ba60de7b43d3cc6c870fb0594c2a2"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de0870f8dc54cc60f3cd040b50c4e6910754a1e69e07db60adfb71a8ba8e64ad" => :sierra
    sha256 "639affe22c0e7647316d9215c46b3afe172985312d9fefedc4159174f6bc22e7" => :el_capitan
    sha256 "7b25340e398db41f72382503fdbcf09329aa2eca2fb3ad3c4c3220e303cc0c53" => :yosemite
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
