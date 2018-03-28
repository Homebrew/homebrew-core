class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.4.tar.gz"
  sha256 "44870378af1821816b28bab5ff6df5f52c3b2091a0b0f7f7d3a88cc41ee91959"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c9f15dc9141ba905b9aafc007dcbf85f94334520bef7b68de5c7e38ad9479ff" => :high_sierra
    sha256 "be3f409544115af353ac783cba2a29c57aa850013d691853b1a1c654006b93ab" => :sierra
    sha256 "08e4b0210506a2874bf156a209365cdaebf835f263f0671e9b5cf48f28c307a8" => :el_capitan
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
