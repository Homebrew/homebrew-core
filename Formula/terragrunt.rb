class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.18.tar.gz"
  sha256 "d996590494629f5856414be46d18420d930cc2eacd02a914cf66d37fc8ab6ca2"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f1b4a19868b19e16b513e76ab2e6345063426cc8f965f3cfbe65aaa5f60dbee" => :sierra
    sha256 "82139bbd3bcaf2bd64919cf3e31f8f40a4db00557127fd8ccd9b5e25842c0d6e" => :el_capitan
    sha256 "61e6c825f0416558bcfc72990133b35a85243f79e8ec90fead16bca80cb2a989" => :yosemite
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
