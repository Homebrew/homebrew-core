class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.0.tar.gz"
  sha256 "6286657a3f821919122e6eb7aef50f6cdd37aca669ca30d0bbae14a790651bae"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d76ec75bab5299843eb619b9e934886fcd286c41343ac8cdba99caa2b71af6e" => :sierra
    sha256 "d80a9b2c68279e7218f529d356e3a3d708bc1ee0144c67ca2029279702730c64" => :el_capitan
    sha256 "c07883b47bfa169884822d25b798b4a989d6d236aea6e5d7f96329e30c75f0d9" => :yosemite
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
