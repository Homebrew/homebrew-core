class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.3.tar.gz"
  sha256 "2cd23054295aae319b714bc31282786e63262b2d390caf8c70bd5150f206c48f"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3845dfbfa27a102d462f8c86a0ce655e18407ff4db2c542a9902d1b72a917ba6" => :sierra
    sha256 "7e73ee1305bb5dc3a0e786062388a45302d617a72f6901b1b4d6915b5efa548c" => :el_capitan
    sha256 "0c09dd1c8725bb94ad29f51fe62328fad867037f1dbbe4701e2f2e397a0ea84e" => :yosemite
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
