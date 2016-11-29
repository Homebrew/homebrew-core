class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.3.0.tar.gz"
  sha256 "9369b133a3ce1d834a06d9aac45a611fb1290b2e1d893ff3d6c752332b5f5835"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c403f4b7a749aab01dd6a5a4b55d00fb4837e5cbce959843f9d4f44548d8c93" => :sierra
    sha256 "5ad1d91eae71c69c2893d2adbacd2f304b0015474b516286716cb2db0295a278" => :el_capitan
    sha256 "059365d96ebc4108d1136344d588444159f54434bd5a91d21a94432deda43c93" => :yosemite
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
