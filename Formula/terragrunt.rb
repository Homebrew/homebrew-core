class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.11.tar.gz"
  sha256 "90e219bce4a45ca374fa24b7b050e56dad57fabc58147fa909ba8749a5a82c5d"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c5e34e5f22d9d8561d72bb95ac87545bb24d675ff59fc364f82279d6a954f5c" => :high_sierra
    sha256 "ad446a9a4c63f5593341c066fb03816c8cf61173e9069c89adb693f36b88da3a" => :sierra
    sha256 "5c9cd2dd3c5edccda345c6d85b17f67f46fcd2f23613bb384306cbab819f4156" => :el_capitan
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
