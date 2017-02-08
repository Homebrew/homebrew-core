class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.9.9.tar.gz"
  sha256 "e5f6f01fcc0b3ffef3aefddcdada38afb064e6c128cef01a65f315cd1d6d0239"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "29e556d4159a9d6d9630659bbff3645914d2e05b9c49fe45383e8124f422f1d2" => :sierra
    sha256 "e75039659528cd3e77a662e718f233ffbf456fe82f1577f8c95d4d1d98730fae" => :el_capitan
    sha256 "a30aec06bcb5699b492b68869b8fe255f5e7f7dcb2faba6b322b10daba7ee49b" => :yosemite
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
