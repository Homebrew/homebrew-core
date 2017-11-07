class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.17.tar.gz"
  sha256 "076f23279f00cf76ee3937029e72fcbb71ba7008ba94679f3b90ffb251e4ee42"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd79d635ef4be53bdf95d49aa3f36731b4ff54e732563c066a08ed03d68bfe3b" => :high_sierra
    sha256 "1f8b03ac63959d367627ec3cafc2f083c2e3a282b68502db9272840aca060634" => :sierra
    sha256 "37a195ee6fdce5cf5e75616ba330efbf9f5dd91950e7be8702ff6d0f67d0d0fb" => :el_capitan
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
