class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.5.tar.gz"
  sha256 "354cd6b15dbab83d807eec26fb70f5565925a13e30ebab9bac61004c041954d3"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce8269d0a49d19f4cef725efa8a8b544d3e3b6b0c502a848e5801759c29588a9" => :high_sierra
    sha256 "f543c6f643ac8c4284af18d16e04530f5d5582b900ffc6406773f6a5c03a25e5" => :sierra
    sha256 "1a6708a9c0168ee2ff05df0f2b27b05c1ac571f25cbe66a67175f3d99b076ccb" => :el_capitan
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
