class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.6.tar.gz"
  sha256 "6a9ee48d5e2897730eb17bffc96de0cbb5d6533f0c075a8a5b405d3d52ffcc14"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0df827f5f0c42c4e0d2efc7b66c9d8f2bb90a6231353ad0c2a6d8fa03e416c78" => :mojave
    sha256 "0fafbcd488717374be47a4c6fb803fc09bec7a26647ddd37eae32f646090aeb7" => :high_sierra
    sha256 "612a2fcf12685656d9150624c12ffde01c266da558df0c6222aa4065b1734888" => :sierra
    sha256 "818c3222541e4ce83818906a3d8b44d37f66cd06d3b46a60aa0d70261c1eaa56" => :el_capitan
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
