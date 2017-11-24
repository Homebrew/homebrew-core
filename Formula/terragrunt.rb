class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.21.tar.gz"
  sha256 "0b265cd3c7640d527fd453f92c19caf27125ed5e8b517aadb667bba026022ae8"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fae88bf20dfc2740859c960838a15dfe230a5f94a09a33be3e276f3db35e318" => :high_sierra
    sha256 "f67b7882158b8b868b6947ee2980700a833e5e2371069e06760a967f36fe3543" => :sierra
    sha256 "3f9d61d8c531c50261d58f22ee8fe21607ca1353f961a94ea9a2c562ed70ec33" => :el_capitan
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
