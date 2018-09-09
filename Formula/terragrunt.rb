class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.8.tar.gz"
  sha256 "0ba536f10f0a2901334f0ead419e454fb872a3fa777b0cede92069ebb94916ca"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f7dc8ff72d61864e18979bc983d2e95081b1d06d14d84f9169f42ddb78ab273" => :mojave
    sha256 "a6d0009e4dc784d9f3eb4ff28a35277a7214b79e1a0e75452f48c033c38d7d5e" => :high_sierra
    sha256 "76b13c28ef117e8cd2d42430f830774b437152d511fced793033e8311d45e3c4" => :sierra
    sha256 "642a2ebfc45531e672458f2ec0f78adc06465b89a09dbafc44aeb5a0b11459c8" => :el_capitan
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
