class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.23.tar.gz"
  sha256 "a986e505ecbb45b1dfcab2a9138d4cefe23d20edca61980c31a4dd4107afd3ea"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1bed2bfb9477a99239768005cffc510a44f61536c05c4c6fe0428eefc15616f" => :sierra
    sha256 "b2b56108be78319124a51105d0bc8a464705217f7e23913aad1b591a3635660b" => :el_capitan
    sha256 "849c10dec2b161fc28fafd6eafda7578cf85d6761e0ddf55fffafef9c9460882" => :yosemite
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
