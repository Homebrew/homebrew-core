class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.2.tar.gz"
  sha256 "906d13a8d0bc9c6cb48ad7f2e0735c3e3cf2663bc38b5175260321951e0b6041"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eae84991ce79b7fc34d299b4dd30a59643895680f66657a2fee4b859c6e335e1" => :high_sierra
    sha256 "66097091f8410a9cdec065fd2afbbb35938e32a04c9246508d6bd1964256e11b" => :sierra
    sha256 "5ee2739f0d73326319742f35b38780b5443753c0eb94e567275434e978eab9dd" => :el_capitan
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
