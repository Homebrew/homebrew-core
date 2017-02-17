class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.10.2.tar.gz"
  sha256 "f9d3dbf2b2071a9b126b204d322a180437a04e6c0dc428899b0e17c58474e7ef"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5496b6748e18aaae79892e5d006bebc9280467263fd036dc671266df82b6a1a" => :sierra
    sha256 "6e54f8797a52a3bc075a859230d86a0ced6b5e27d3baa1a5448e3f01047024ae" => :el_capitan
    sha256 "586ed85e7c88c741f145693fb97dfd01c089af042c5d815cb0441f5bb06c6a02" => :yosemite
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
