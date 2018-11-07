class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.17.1.tar.gz"
  sha256 "4503d2d0bf39af6c2c0c326612d1073d1b79668abe4090a2416a0cf7f325eff0"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7aff3f8c90c766e71a8cc97c1b9e3ebbf7004ef34d0160a63cd06514fc98dbad" => :mojave
    sha256 "bb3c142273f397f0bbf6d0d185606b259ac4d72bc6876595bd3365bfa6a8822b" => :high_sierra
    sha256 "bb4933a1d4cd6930d590239fe5ea816309df23296d8611cb34ab4d629acb5d1a" => :sierra
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
