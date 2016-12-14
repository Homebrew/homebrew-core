class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.6.3.tar.gz"
  sha256 "848ce81767b6f98503bc85e692eff1170d26119d51b9edddcd366c23ed51ca59"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8962d897f0dcc3e4795d4977c053cb3c8d114e4b190ce3f1c7ea2471e26d31e" => :sierra
    sha256 "9a7c3567331d4c2bbd959122e707faa5510c550d389f5ac173e06cc45f834103" => :el_capitan
    sha256 "7b847413a8df3f094c1617d6af6a1fcf579240dcaf65b9921a343ac5dc6b5489" => :yosemite
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
