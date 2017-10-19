class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.11.tar.gz"
  sha256 "3e28311c682d613a49e0dd38b07c9002527f6b0b6cd0c01bac8bfe8d00ec6341"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1be41991cb789ab6b9a575e6c7fb6ed53891ebca7defc5a7a0b89d64955f5fb" => :high_sierra
    sha256 "91ebff784657347e86269d1aff80d299082be1bc44ef749c517ec82ad9a81d25" => :sierra
    sha256 "22fd24cb81f6cfdeec60b9080de2c2b522498b986eca75c8db70d8804eb989c6" => :el_capitan
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
